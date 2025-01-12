import Foundation
import LocStringCore
import LocSwiftCore
import XCResourceUtil

protocol StringsLocalizationItemMerger: AnyObject {
    func itemsByMerging(
        itemsInSourceCode: [LocalizationItem],
        itemsInStrings: [LocalizationItem],
        mergeStrategy: MergeStrategy,
        verifiesComments: Bool
    ) -> [LocalizationItem]
}

extension StringKeyToStringsGenerator {
    public struct CommandNameSet: Sendable {
        public var exclude: String
        
        public init(exclude: String) {
            self.exclude = exclude
        }
    }
    
    public struct Request: Sendable {
        public var sourceCodeURL: URL
        public var resourcesURL: URL
        public var tableName: String
        public var configurationsByLanguage: [LanguageID: LocalizationConfiguration]
        public var includesComments: Bool
        public var sortOrder: SortOrder
        
        public init(
            sourceCodeURL: URL,
            resourcesURL: URL,
            tableName: String = "Localizable",
            configurationsByLanguage: [LanguageID: LocalizationConfiguration] = [
                .all: .init(mergeStrategy: .doNotAdd, verifiesComments: true)
            ],
            includesComments: Bool = true,
            sortOrder: SortOrder = .occurrence
        ) {
            self.sourceCodeURL = sourceCodeURL
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.configurationsByLanguage = configurationsByLanguage
            self.includesComments = includesComments
            self.sortOrder = sortOrder
        }
    }
    
    public struct LocalizationConfiguration: Sendable {
        public var mergeStrategy: MergeStrategy
        public var verifiesComments: Bool
        
        public init(mergeStrategy: MergeStrategy, verifiesComments: Bool) {
            self.mergeStrategy = mergeStrategy
            self.verifiesComments = verifiesComments
        }
    }
}

public class StringKeyToStringsGenerator {
    private let languageDetector: LanguageDetector
    private let sourceCodeImporter: LocalizationItemImporter
    private let stringsImporter: LocalizationItemImporter
    private let localizationItemMerger: StringsLocalizationItemMerger
    private let stringsGenerator: StringsGenerator
    
    init(languageDetector: LanguageDetector,
         sourceCodeImporter: LocalizationItemImporter,
         stringsImporter: LocalizationItemImporter,
         localizationItemMerger: StringsLocalizationItemMerger,
         stringsGenerator: StringsGenerator
    ) {
        self.languageDetector = languageDetector
        self.sourceCodeImporter = sourceCodeImporter
        self.stringsImporter = stringsImporter
        self.localizationItemMerger = localizationItemMerger
        self.stringsGenerator = stringsGenerator
    }
    
    public convenience init(commandNameSet: CommandNameSet) {
        self.init(
            languageDetector: DefaultLanguageDetector(
                detector: LocStringCore.DefaultLanguageDetector()),
            sourceCodeImporter: LocalizationItemImporterFilterDecorator(
                decoratee: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter()),
                filter: StringsItemFilter(commandNameForExclusion: commandNameSet.exclude)),
            stringsImporter: LocalizationItemImporterIDDecorator(
                decoratee: StringsImporter()),
            localizationItemMerger: DefaultStringsLocalizationItemMerger(),
            stringsGenerator: DefaultStringsGenerator())
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
            
            let stringsFileURL = request.resourcesURL
                .appendingPathComponents(language: language.rawValue, tableName: request.tableName)
            
            let itemsInStrings = try stringsImporter.import(at: stringsFileURL)
            
            var mergedItems = localizationItemMerger.itemsByMerging(
                itemsInSourceCode: itemsInSourceCode,
                itemsInStrings: itemsInStrings,
                mergeStrategy: config.mergeStrategy,
                verifiesComments: config.verifiesComments)
            
            if !request.includesComments {
                mergedItems = mergedItems.map({ $0.with(\.comment, nil) })
            }
            
            result[language] = stringsGenerator.generate(from: mergedItems)
        }
    }
}
