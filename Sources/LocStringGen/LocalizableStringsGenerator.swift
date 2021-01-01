import Foundation
import XCResourceUtil

protocol LanguageDetector: AnyObject {
    func detect(at url: URL) throws -> [LanguageID]
}

protocol LocalizationItemImporter: AnyObject {
    func `import`(at url: URL) throws -> [LocalizationItem]
}

protocol PropertyListGenerator: AnyObject {
    func generate(from items: [LocalizationItem]) -> String
}

extension LocalizableStringsGenerator {
    public struct Request {
        public var sourceCodeURL: URL
        public var resourcesURL: URL
        public var tableName: String
        public var defaultValueStrategy: ValueStrategy
        public var valueStrategiesByLanguage: [LanguageID: ValueStrategy]
        public var sortOrder: SortOrder
        
        public init(sourceCodeURL: URL,
                    resourcesURL: URL,
                    tableName: String = "Localizable",
                    defaultValueStrategy: ValueStrategy = .custom("UNTRANSLATED-STRING"),
                    valueStrategiesByLanguage: [LanguageID: ValueStrategy] = [:],
                    sortOrder: SortOrder = .occurrence
        ) {
            self.sourceCodeURL = sourceCodeURL
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.defaultValueStrategy = defaultValueStrategy
            self.valueStrategiesByLanguage = valueStrategiesByLanguage
            self.sortOrder = sortOrder
        }
    }
    
    public enum ValueStrategy {
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
    
    public convenience init() {
        self.init(languageDetector: ActualLanguageDetector(),
                  sourceImporter: SwiftSourceImporter(),
                  targetImporter: ASCIIPlistImporter(),
                  plistGenerator: ASCIIPlistGenerator())
    }
    
    public func generate(for request: Request) throws -> [LanguageID: String] {
        let sourceItems = try sourceImporter.import(at: request.sourceCodeURL)
        let languages = try languageDetector.detect(at: request.resourcesURL)
        
        return try languages.reduce(into: [:]) { result, language in
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
