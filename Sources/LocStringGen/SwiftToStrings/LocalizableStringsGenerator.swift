import Foundation
import XCResourceUtil

extension LocalizableStringsGenerator {
    public struct CommandNameSet {
        public var exclude: String
        
        public init(exclude: String) {
            self.exclude = exclude
        }
    }
    
    public struct Request {
        public var sourceCodeURL: URL
        public var resourcesURL: URL
        public var tableName: String
        public var languages: [LanguageID]?
        public var defaultValueStrategy: ValueStrategy
        public var valueStrategiesByLanguage: [LanguageID: ValueStrategy]
        public var sortOrder: SortOrder
        
        public init(sourceCodeURL: URL,
                    resourcesURL: URL,
                    tableName: String = "Localizable",
                    languages: [LanguageID]? = nil,
                    defaultValueStrategy: ValueStrategy = .custom("UNTRANSLATED-TEXT"),
                    valueStrategiesByLanguage: [LanguageID: ValueStrategy] = [:],
                    sortOrder: SortOrder = .occurrence
        ) {
            self.sourceCodeURL = sourceCodeURL
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.languages = languages
            self.defaultValueStrategy = defaultValueStrategy
            self.valueStrategiesByLanguage = valueStrategiesByLanguage
            self.sortOrder = sortOrder
        }
    }
    
    public enum ValueStrategy: Equatable {
        case comment
        case key
        case custom(String)
    }
    
    public enum SortOrder {
        case occurrence
        case key
    }
}

public class LocalizableStringsGenerator {
    private let languageDetector: LanguageDetector
    private let sourceImporter: LocalizationItemImporter
    private let targetImporter: LocalizationItemImporter
    private let plistGenerator: PropertyListGenerator
    
    init(languageDetector: LanguageDetector,
         sourceImporter: LocalizationItemImporter,
         targetImporter: LocalizationItemImporter,
         plistGenerator: PropertyListGenerator
    ) {
        self.languageDetector = languageDetector
        self.sourceImporter = sourceImporter
        self.targetImporter = targetImporter
        self.plistGenerator = plistGenerator
    }
    
    public convenience init(commandNameSet: CommandNameSet) {
        self.init(
            languageDetector: DefaultLanguageDetector(),
            sourceImporter: SwiftLocalizationItemImporter(
                enumerationImporter: FilterableStringEnumerationImporter(
                    importer: SwiftStringEnumerationImporter(),
                    commandNameOfExclusion: commandNameSet.exclude)),
            targetImporter: ASCIIPlistImporter(),
            plistGenerator: ASCIIPlistGenerator())
    }
    
    public func generate(for request: Request) throws -> [LanguageID: String] {
        let sourceItems = try sourceImporter.import(at: request.sourceCodeURL)
        let languages = try languageDetector.detect(at: request.resourcesURL)
        let filteredLanguages = request.languages?.filter({ languages.contains($0) }) ?? languages
        
        return try filteredLanguages.reduce(into: [:]) { result, language in
            let valueStrategy = request.valueStrategiesByLanguage[language]
                ?? request.defaultValueStrategy
            
            let stringsFileURL = request.resourcesURL
                .appendingPathComponents(language: language.rawValue, tableName: request.tableName)
            
            let targetItems = try targetImporter.import(at: stringsFileURL)
            
            let combinedItems = sourceItems
                .map({ $0.applying(valueStrategy) })
                .combining(targetItems)
                .sorted(by: request.sortOrder)
            
            result[language] = plistGenerator.generate(from: combinedItems)
        }
    }
}
