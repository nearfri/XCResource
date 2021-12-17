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
        public var mergeStrategies: [LanguageID: MergeStrategy]
        public var shouldCompareComments: Bool
        public var sortOrder: SortOrder
        
        public init(
            sourceCodeURL: URL,
            resourcesURL: URL,
            tableName: String = "Localizable",
            mergeStrategies: [LanguageID: MergeStrategy] = [.all: .doNotAdd],
            shouldCompareComments: Bool = true,
            sortOrder: SortOrder = .occurrence
        ) {
            self.sourceCodeURL = sourceCodeURL
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.mergeStrategies = mergeStrategies
            self.shouldCompareComments = shouldCompareComments
            self.sortOrder = sortOrder
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
        let sourceItems = try sourceImporter
            .import(at: request.sourceCodeURL)
            .filter({ !$0.commentContainsPluralVariables })
        
        let languages = try determineLanguages(for: request)
        
        return try languages.reduce(into: [:]) { result, language in
            let strategy = request.mergeStrategies[language] ?? request.mergeStrategies[.all]!
            
            let stringsFileURL = request.resourcesURL
                .appendingPathComponents(language: language.rawValue, tableName: request.tableName)
            
            let targetItems = try targetImporter.import(at: stringsFileURL)
            
            let combinedItems = { () -> [LocalizationItem] in
                switch strategy {
                case .add(let addingMethod):
                    return sourceItems
                        .map({ $0.applying(addingMethod) })
                        .combined(with: targetItems,
                                  comparingComments: request.shouldCompareComments)
                case .doNotAdd:
                    return sourceItems
                        .combinedIntersection(targetItems,
                                              comparingComments: request.shouldCompareComments)
                }
            }().sorted(by: request.sortOrder)
            
            result[language] = plistGenerator.generate(from: combinedItems)
        }
    }
    
    private func determineLanguages(for request: Request) throws -> [LanguageID] {
        let availableLanguages = try languageDetector.detect(at: request.resourcesURL)
        let requestedLanguages = Set(request.mergeStrategies.keys)
        
        if requestedLanguages.contains(.all) {
            return availableLanguages
        }
        
        return availableLanguages.filter(requestedLanguages.contains(_:))
    }
}
