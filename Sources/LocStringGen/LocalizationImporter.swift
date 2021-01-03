import Foundation

protocol LocalizationDocumentDecoder: AnyObject {
    func decode(from string: String) throws -> LocalizationDocument
}

extension LocalizationImporter {
    public struct Request {
        public var documentSource: DocumentSource
        
        public init(documentSource: DocumentSource) {
            self.documentSource = documentSource
        }
    }
    
    public enum DocumentSource {
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
    private let documentDecoder: LocalizationDocumentDecoder
    private let plistGenerator: PropertyListGenerator
    
    init(documentDecoder: LocalizationDocumentDecoder,
         plistGenerator: PropertyListGenerator
    ) {
        self.documentDecoder = documentDecoder
        self.plistGenerator = plistGenerator
    }
    
    public convenience init() {
        self.init(documentDecoder: CSVDocumentDecoder(),
                  plistGenerator: ASCIIPlistGenerator())
    }
    
    public func generate(for request: Request) throws -> [LanguageID: String] {
        let document = try documentDecoder.decode(from: try request.documentSource.contents())
        let sections = try document.toSections()
        
        return sections.reduce(into: [:]) { result, section in
            result[section.language] = plistGenerator.generate(from: section.items)
        }
    }
}
