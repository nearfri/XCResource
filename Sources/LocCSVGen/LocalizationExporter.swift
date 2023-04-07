import Foundation
import LocStringCore

protocol LocalizationTableEncoder: AnyObject {
    func encode(_ table: LocalizationTable) throws -> String
}

extension LocalizationExporter {
    public struct Request {
        public var resourcesURL: URL
        public var tableName: String
        public var preferredLanguages: [LanguageID]
        public var emptyTranslationEncoding: String
        
        public init(resourcesURL: URL,
                    tableName: String = "Localizable",
                    preferredLanguages: [LanguageID] = [],
                    emptyTranslationEncoding: String = ""
        ) {
            self.resourcesURL = resourcesURL
            self.tableName = tableName
            self.preferredLanguages = preferredLanguages
            self.emptyTranslationEncoding = emptyTranslationEncoding
        }
    }
}

public class LocalizationExporter {
    private let languageDetector: LanguageDetector
    private let itemImporter: LocalizationItemImporter
    private let languageFormatter: LanguageFormatter
    private let tableEncoder: LocalizationTableEncoder
    
    init(languageDetector: LanguageDetector,
         itemImporter: LocalizationItemImporter,
         languageFormatter: LanguageFormatter,
         tableEncoder: LocalizationTableEncoder
    ) {
        self.languageDetector = languageDetector
        self.itemImporter = itemImporter
        self.languageFormatter = languageFormatter
        self.tableEncoder = tableEncoder
    }
    
    public convenience init() {
        self.init(languageDetector: DefaultLanguageDetector(),
                  itemImporter: StringsImporter(),
                  languageFormatter: DefaultLanguageFormatter(),
                  tableEncoder: CSVTableEncoder())
    }
    
    public var headerStyle: LanguageFormatterStyle {
        get { languageFormatter.style }
        set { languageFormatter.style = newValue }
    }
    
    public func generate(for request: Request) throws -> String {
        let sections = try importSections(with: request)
        let table = LocalizationTable(sections: sections,
                                      languageFormatter: languageFormatter,
                                      emptyTranslationEncoding: request.emptyTranslationEncoding)
        return try tableEncoder.encode(table)
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
