import Foundation
import ResourceKeyUtil

protocol LanguageDetector: AnyObject {
    func detect(at url: URL) throws -> [LanguageID]
}

protocol LocalizationItemImporter: AnyObject {
    func `import`(at url: URL) throws -> [LocalizationItem]
}

protocol PropertyListGenerator: AnyObject {
    func generate(from items: [LocalizationItem]) -> String
}

extension LocalizedStringGenerator {
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

public class LocalizedStringGenerator {
    private let languageDetector: LanguageDetector
    private let localizationSourceImporter: LocalizationItemImporter
    private let localizationTargetImporter: LocalizationItemImporter
    private let plistGenerator: PropertyListGenerator
    
    init(languageDetector: LanguageDetector,
         localizationSourceImporter: LocalizationItemImporter,
         localizationTargetImporter: LocalizationItemImporter,
         plistGenerator: PropertyListGenerator
    ) {
        self.languageDetector = languageDetector
        self.localizationSourceImporter = localizationSourceImporter
        self.localizationTargetImporter = localizationTargetImporter
        self.plistGenerator = plistGenerator
    }
    
    public convenience init() {
        self.init(languageDetector: ActualLanguageDetector(),
                  localizationSourceImporter: LocalizationSourceImporter(),
                  localizationTargetImporter: LocalizationTargetImporter(),
                  plistGenerator: ActualPropertyListGenerator())
    }
    
    public func generate(for request: Request) throws -> [LanguageID: String] {
        let sourceItems = try localizationSourceImporter.import(at: request.sourceCodeURL)
        let languages = try languageDetector.detect(at: request.resourcesURL)
        
        return try languages.reduce(into: [:]) { result, language in
            let valueStrategy = request.valueStrategiesByLanguage[language]
                ?? request.defaultValueStrategy
            
            let stringsFileURL = request.resourcesURL
                .appendingPathComponents(language: language.rawValue, tableName: request.tableName)
            
            let targetItems = try localizationTargetImporter.import(at: stringsFileURL)
            
            let combinedItems = sourceItems
                .map({ $0.applying(valueStrategy) })
                .combining(targetItems)
                .sorted(by: request.sortOrder)
            
            result[language] = plistGenerator.generate(from: combinedItems)
        }
    }
}
