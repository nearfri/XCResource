import Foundation

protocol LanguageDetector: AnyObject {
    func detect(at url: URL) throws -> [LanguageID]
}

protocol LocalizationItemFetcher: AnyObject {
    func fetch(at url: URL) throws -> [LocalizationItem]
}

protocol PropertyListGenerator: AnyObject {
    func generate(from items: [LocalizationItem]) -> String
}

extension LocalizedStringGenerator {
    public struct CodeRequest {
        public var sourceCodeURL: URL
        public var resourcesURL: URL
        public var tableName: String
        public var defaultValueStrategy: ValueStrategy
        public var valueStrategiesByLanguage: [LanguageID: ValueStrategy]
        
        public init(sourceCodeURL: URL,
                    resourcesURL: URL,
                    tableName: String = "Localizable",
                    defaultValueStrategy: ValueStrategy = .custom("UNTRANSLATED-STRING"),
                    valueStrategiesByLanguage: [LanguageID: ValueStrategy] = [:]
        ) {
            self.sourceCodeURL = sourceCodeURL
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.defaultValueStrategy = defaultValueStrategy
            self.valueStrategiesByLanguage = valueStrategiesByLanguage
        }
    }
    
    public enum ValueStrategy {
        case comment
        case key
        case custom(String)
    }
}

public class LocalizedStringGenerator {
    private let languageDetector: LanguageDetector
    private let localizationSourceFetcher: LocalizationItemFetcher
    private let localizationTargetFetcher: LocalizationItemFetcher
    private let plistGenerator: PropertyListGenerator
    
    init(languageDetector: LanguageDetector,
         localizationSourceFetcher: LocalizationItemFetcher,
         localizationTargetFetcher: LocalizationItemFetcher,
         plistGenerator: PropertyListGenerator
    ) {
        self.languageDetector = languageDetector
        self.localizationSourceFetcher = localizationSourceFetcher
        self.localizationTargetFetcher = localizationTargetFetcher
        self.plistGenerator = plistGenerator
    }
    
    public convenience init() {
        self.init(languageDetector: ActualLanguageDetector(),
                  localizationSourceFetcher: LocalizationSourceFetcher(),
                  localizationTargetFetcher: LocalizationTargetFetcher(),
                  plistGenerator: ActualPropertyListGenerator())
    }
    
    public func generate(for request: CodeRequest) throws -> [LanguageID: String] {
        let sourceItems = try localizationSourceFetcher.fetch(at: request.sourceCodeURL)
        let languages = try languageDetector.detect(at: request.resourcesURL)
        
        return try languages.reduce(into: [:]) { result, language in
            let valueStrategy = request.valueStrategiesByLanguage[language]
                ?? request.defaultValueStrategy
            
            let stringsFileURL = request.resourcesURL
                .appendingPathComponent("\(language).lproj/\(request.tableName).strings")
            
            let targetItems = try localizationTargetFetcher.fetch(at: stringsFileURL)
            
            let combinedItems = sourceItems
                .map({ $0.applying(valueStrategy) })
                .combining(targetItems)
                .sorted(by: { $0.key < $1.key })
            
            result[language] = plistGenerator.generate(from: combinedItems)
        }
    }
}
