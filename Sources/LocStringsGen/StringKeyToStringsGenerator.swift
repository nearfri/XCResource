import Foundation
import LocStringCore
import LocSwiftCore
import XCResourceUtil

extension StringKeyToStringsGenerator {
    public struct Request {
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
    
    public struct LocalizationConfiguration {
        public var mergeStrategy: MergeStrategy
        public var verifiesComments: Bool
        
        public init(mergeStrategy: MergeStrategy, verifiesComments: Bool) {
            self.mergeStrategy = mergeStrategy
            self.verifiesComments = verifiesComments
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

public class StringKeyToStringsGenerator {
    private let languageDetector: LanguageDetector
    private let sourceCodeImporter: LocalizationItemImporter
    private let stringsImporter: LocalizationItemImporter
    private let stringsGenerator: StringsGenerator
    
    init(languageDetector: LanguageDetector,
         sourceCodeImporter: LocalizationItemImporter,
         stringsImporter: LocalizationItemImporter,
         stringsGenerator: StringsGenerator
    ) {
        self.languageDetector = languageDetector
        self.sourceCodeImporter = sourceCodeImporter
        self.stringsImporter = stringsImporter
        self.stringsGenerator = stringsGenerator
    }
    
    public convenience init() {
        self.init(
            languageDetector: DefaultLanguageDetector(),
            sourceCodeImporter: LocalizationItemImporterSingularFilterDecorator(
                decoratee: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter())),
            stringsImporter: LocalizationItemImporterIDDecorator(
                decoratee: StringsLocalizationItemImporter()),
            stringsGenerator: DefaultStringsGenerator())
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
            
            var outputItems = { () -> [LocalizationItem] in
                switch config.mergeStrategy {
                case .add(let addingMethod):
                    return itemsInSourceCode
                        .map({ $0.applying(addingMethod) })
                        .combined(with: baseItems, verifyingComments: config.verifiesComments)
                case .doNotAdd:
                    return itemsInSourceCode
                        .combinedIntersection(baseItems, verifyingComments: config.verifiesComments)
                }
            }()
            
            if !request.includesComments {
                outputItems = outputItems.map({ $0.setting(\.comment, nil) })
            }
            
            outputItems = outputItems.sorted(by: request.sortOrder)
            
            result[language] = stringsGenerator.generate(from: outputItems)
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
