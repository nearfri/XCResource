import Foundation
import XCResourceUtil

extension LocalizableStringsGenerator {
    public struct Request {
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
                .all: .init(mergeStrategy: .doNotAdd, verifiesComment: true)
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
    
    public struct LocalizationConfiguration {
        public var mergeStrategy: MergeStrategy
        public var verifiesComment: Bool
        
        public init(mergeStrategy: MergeStrategy, verifiesComment: Bool) {
            self.mergeStrategy = mergeStrategy
            self.verifiesComment = verifiesComment
        }
    }
    
    public enum MergeStrategy: Equatable {
        case add(AddingMethod)
        case doNotAdd
        
        public enum AddingMethod: Equatable {
            case comment
            case key
            case label(String)
        }
    }
    
    public enum SortOrder {
        case occurrence
        case key
    }
}

public class LocalizableStringsGenerator {
    private let languageDetector: LanguageDetector
    private let sourceCodeImporter: LocalizationItemImporter
    private let stringsImporter: LocalizationItemImporter
    private let stringsGenerator: PropertyListGenerator
    
    init(languageDetector: LanguageDetector,
         sourceCodeImporter: LocalizationItemImporter,
         stringsImporter: LocalizationItemImporter,
         stringsGenerator: PropertyListGenerator
    ) {
        self.languageDetector = languageDetector
        self.sourceCodeImporter = sourceCodeImporter
        self.stringsImporter = stringsImporter
        self.stringsGenerator = stringsGenerator
    }
    
    public convenience init() {
        self.init(
            languageDetector: DefaultLanguageDetector(),
            sourceCodeImporter: SingularLocalizationItemImporterDecorator(
                importer: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter())),
            stringsImporter: ASCIIPlistImporter(),
            stringsGenerator: ASCIIPlistGenerator())
    }
    
    public func generate(for request: Request) throws -> [LanguageID: String] {
        let itemsInSourceCode = try sourceCodeImporter.import(at: request.sourceCodeURL)
        
        let languages = try determineLanguages(for: request)
        
        return try languages.reduce(into: [:]) { result, language in
            let configs = request.configurationsByLanguage
            let config = configs[language] ?? configs[.all]!
            
            let stringsFileURL = request.resourcesURL
                .appendingPathComponents(language: language.rawValue, tableName: request.tableName)
            
            let baseItems = try stringsImporter.import(at: stringsFileURL)
            
            let combinedItems = { () -> [LocalizationItem] in
                switch config.mergeStrategy {
                case .add(let addingMethod):
                    return itemsInSourceCode
                        .map({ $0.applying(addingMethod) })
                        .combined(with: baseItems, verifyingComments: config.verifiesComment)
                case .doNotAdd:
                    return itemsInSourceCode
                        .combinedIntersection(baseItems, verifyingComments: config.verifiesComment)
                }
            }().sorted(by: request.sortOrder)
            
            result[language] = stringsGenerator.generate(from: combinedItems)
        }
    }
    
    private func determineLanguages(for request: Request) throws -> [LanguageID] {
        let availableLanguages = try languageDetector.detect(at: request.resourcesURL)
        let requestedLanguages = Set(request.configurationsByLanguage.keys)
        
        if requestedLanguages.contains(.all) {
            return availableLanguages
        }
        
        return availableLanguages.filter(requestedLanguages.contains(_:))
    }
}
