import Foundation

protocol LocalizationDocumentEncoder: AnyObject {
    func encode(_ document: LocalizationDocument) throws -> String
}

extension LocalizationExporter {
    public struct Request {
        public var resourcesURL: URL
        public var tableName: String
        public var preferredLanguages: [LanguageID]
        
        public init(resourcesURL: URL,
                    tableName: String = "Localizable",
                    preferredLanguages: [LanguageID] = []
        ) {
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.preferredLanguages = preferredLanguages
        }
    }
}

public class LocalizationExporter {
    private let languageDetector: LanguageDetector
    private let itemImporter: LocalizationItemImporter
    private let languageFormatter: LanguageFormatter
    private let documentEncoder: LocalizationDocumentEncoder
    
    init(languageDetector: LanguageDetector,
         itemImporter: LocalizationItemImporter,
         languageFormatter: LanguageFormatter,
         documentEncoder: LocalizationDocumentEncoder
    ) {
        self.languageDetector = languageDetector
        self.itemImporter = itemImporter
        self.languageFormatter = languageFormatter
        self.documentEncoder = documentEncoder
    }
    
    public convenience init() {
        self.init(languageDetector: ActualLanguageDetector(),
                  itemImporter: ASCIIPlistImporter(),
                  languageFormatter: ActualLanguageFormatter(),
                  documentEncoder: CSVDocumentEncoder())
    }
    
    public var headerStyle: LanguageFormatterStyle {
        get { languageFormatter.style }
        set { languageFormatter.style = newValue }
    }
    
    public func generate(for request: Request) throws -> String {
        let sections = try importSections(with: request)
        let document = LocalizationDocument(sections: sections,
                                            languageFormatter: languageFormatter)
        return try documentEncoder.encode(document)
    }
    
    private func importSections(with request: Request) throws -> [LocalizationSection] {
        let languages = try languageDetector.detect(at: request.resourcesURL)
            .sorted(usingPreferredLanguages: request.preferredLanguages)
        
        return try languages.reduce(into: [], { result, language in
            let stringsFileURL = request.resourcesURL
                .appendingPathComponents(language: language.rawValue, tableName: request.tableName)
            
            let items = try itemImporter.import(at: stringsFileURL)
            result.append(LocalizationSection(language: language, items: items))
        })
    }
}
