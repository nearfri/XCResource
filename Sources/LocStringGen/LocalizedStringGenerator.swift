import Foundation

protocol LanguageDetector {
    func detect(at url: URL) -> [LanguageID]
}

protocol LocalizedStringFetcher: AnyObject {
    func fetch(at url: URL) throws -> [LocalizedStringItem]
}

protocol PropertyListGenerator: AnyObject {
    func generate(from items: [LocalizedStringItem]) -> String
}

extension LocalizedStringGenerator {
    public struct CodeRequest {
        public var sourceCodeURL: URL
        public var resourcesURL: URL
        public var tableName: String?
        
        public init(sourceCodeURL: URL, resourcesURL: URL, tableName: String? = nil) {
            self.sourceCodeURL = sourceCodeURL
            self.resourcesURL = resourcesURL
            self.tableName = tableName
        }
    }
}

public class LocalizedStringGenerator {
    private let languageDetector: LanguageDetector
    private let baseItemFetcher: LocalizedStringFetcher
    private let localizedItemFetcher: LocalizedStringFetcher
    private let plistGenerator: PropertyListGenerator
    
    init(languageDetector: LanguageDetector,
         baseItemFetcher: LocalizedStringFetcher,
         localizedItemFetcher: LocalizedStringFetcher,
         plistGenerator: PropertyListGenerator
    ) {
        self.languageDetector = languageDetector
        self.baseItemFetcher = baseItemFetcher
        self.localizedItemFetcher = localizedItemFetcher
        self.plistGenerator = plistGenerator
    }
    
    public func generate(for request: CodeRequest) throws -> [LanguageID: String] {
        let baseItems = try baseItemFetcher.fetch(at: request.sourceCodeURL)
        let languageIDs = languageDetector.detect(at: request.resourcesURL)
        let stringsFilename = (request.tableName ?? "Localizable") + ".strings"
        
        return try languageIDs.reduce(into: [:]) { result, languageID in
            let stringsFileURL = request.resourcesURL
                .appendingPathComponent("\(languageID).lproj")
                .appendingPathComponent(stringsFilename)
            
            let localizedItems = try localizedItemFetcher.fetch(at: stringsFileURL)
            // merge baseItems and localizedItems
            result[languageID] = plistGenerator.generate(from: baseItems)
        }
    }
}
