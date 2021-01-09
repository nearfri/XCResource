import Foundation

protocol LocalizationTableDecoder: AnyObject {
    func decode(from string: String) throws -> LocalizationTable
}

extension LocalizationImporter {
    public struct Request {
        public var tableSource: TableSource
        public var includesEmptyFields: Bool
        
        public init(tableSource: TableSource, includesEmptyFields: Bool = false) {
            self.tableSource = tableSource
            self.includesEmptyFields = includesEmptyFields
        }
    }
    
    public enum TableSource {
        case text(String)
        case file(URL)
        
        public func contents() throws -> String {
            switch self {
            case .text(let string):
                return string
            case .file(let url):
                return try String(contentsOf: url)
            }
        }
    }
}

public class LocalizationImporter {
    private let tableDecoder: LocalizationTableDecoder
    private let languageFormatter: LanguageFormatter
    private let plistGenerator: PropertyListGenerator
    
    init(tableDecoder: LocalizationTableDecoder,
         languageFormatter: LanguageFormatter,
         plistGenerator: PropertyListGenerator
    ) {
        self.tableDecoder = tableDecoder
        self.languageFormatter = languageFormatter
        self.plistGenerator = plistGenerator
    }
    
    public convenience init() {
        self.init(tableDecoder: CSVTableDecoder(),
                  languageFormatter: ActualLanguageFormatter(),
                  plistGenerator: ASCIIPlistGenerator())
    }
    
    public var headerStyle: LanguageFormatterStyle {
        get { languageFormatter.style }
        set { languageFormatter.style = newValue }
    }
    
    public func generate(for request: Request) throws -> [LanguageID: String] {
        let table = try tableDecoder.decode(from: try request.tableSource.contents())
        let sections = try table.toSections(languageFormatter: languageFormatter,
                                            includeEmptyFields: request.includesEmptyFields)
        
        return sections.reduce(into: [:]) { result, section in
            result[section.language] = plistGenerator.generate(from: section.items)
        }
    }
}
