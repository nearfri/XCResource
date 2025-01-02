import Foundation
import LocStringCore
import LocSwiftCore
import XCResourceUtil

protocol StringsdictLocalizationItemMerger: AnyObject {
    func itemsByMerging(
        itemsInSourceCode: [LocalizationItem],
        itemsInStringsdict: [LocalizationItem],
        mergeStrategy: MergeStrategy
    ) -> [LocalizationItem]
}

protocol StringsdictMerger: AnyObject {
    func plistByMerging(localizationItems: [LocalizationItem], plist: Plist) throws -> Plist
}

extension StringKeyToStringsdictGenerator {
    public struct CommandNameSet: Sendable {
        public var include: String
        
        public init(include: String) {
            self.include = include
        }
    }
    
    public struct Request: Sendable {
        public var sourceCodeURL: URL
        public var resourcesURL: URL
        public var tableName: String
        public var configurationsByLanguage: [LanguageID: LocalizationConfiguration]
        public var sortOrder: SortOrder
        
        public init(
            sourceCodeURL: URL,
            resourcesURL: URL,
            tableName: String = "Localizable",
            configurationsByLanguage: [LanguageID: LocalizationConfiguration] = [
                .all: .init(mergeStrategy: .doNotAdd)
            ],
            sortOrder: SortOrder = .occurrence
        ) {
            self.sourceCodeURL = sourceCodeURL
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.configurationsByLanguage = configurationsByLanguage
            self.sortOrder = sortOrder
        }
    }
    
    public struct LocalizationConfiguration: Sendable {
        public var mergeStrategy: MergeStrategy
        
        public init(mergeStrategy: MergeStrategy) {
            self.mergeStrategy = mergeStrategy
        }
    }
}

public class StringKeyToStringsdictGenerator {
    private let languageDetector: LanguageDetector
    private let sourceCodeImporter: LocalizationItemImporter
    private let stringsdictImporter: StringsdictImporter
    private let localizationItemMerger: StringsdictLocalizationItemMerger
    private let stringsdictMerger: StringsdictMerger
    
    init(languageDetector: LanguageDetector,
         sourceCodeImporter: LocalizationItemImporter,
         stringsdictImporter: StringsdictImporter,
         localizationItemMerger: StringsdictLocalizationItemMerger,
         stringsdictMerger: StringsdictMerger
    ) {
        self.languageDetector = languageDetector
        self.sourceCodeImporter = sourceCodeImporter
        self.stringsdictImporter = stringsdictImporter
        self.localizationItemMerger = localizationItemMerger
        self.stringsdictMerger = stringsdictMerger
    }
    
    public convenience init(commandNameSet: CommandNameSet) {
        self.init(
            languageDetector: DefaultLanguageDetector(
                detector: LocStringCore.DefaultLanguageDetector()),
            sourceCodeImporter: LocalizationItemImporterFilterDecorator(
                decoratee: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter()),
                filter: StringsdictItemFilter(commandNameForInclusion: commandNameSet.include)),
            stringsdictImporter: StringsdictImporterIDDecorator(
                decoratee: DefaultStringsdictImporter()),
            localizationItemMerger: DefaultStringsdictLocalizationItemMerger(),
            stringsdictMerger: DefaultStringsdictMerger())
    }
    
    public func generate(for request: Request) throws -> [LanguageID: String] {
        let itemsInSourceCode = try sourceCodeImporter
            .import(at: request.sourceCodeURL)
            .sorted(by: request.sortOrder)
        
        let languages = try languageDetector.detect(
            at: request.resourcesURL,
            allowedLanguages: request.configurationsByLanguage.keys)
        
        return try languages.reduce(into: [:]) { result, language in
            let configs = request.configurationsByLanguage
            let config = configs[language] ?? configs[.all]!
            
            let stringsdictFileURL = request.resourcesURL
                .appendingPathComponents(
                    language: language.rawValue,
                    tableName: request.tableName,
                    tableType: .stringsdict)
            
            let plist = try Plist(contentsOf: stringsdictFileURL)
            let itemsInStringsdict = try stringsdictImporter.import(from: plist)
            
            let mergedItems = localizationItemMerger.itemsByMerging(
                itemsInSourceCode: itemsInSourceCode,
                itemsInStringsdict: itemsInStringsdict,
                mergeStrategy: config.mergeStrategy)
            
            let mergedPlist = try stringsdictMerger.plistByMerging(
                localizationItems: mergedItems,
                plist: plist)
            
            result[language] = mergedPlist.xmlDocumentString
        }
    }
}
