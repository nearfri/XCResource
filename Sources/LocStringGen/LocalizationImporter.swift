import Foundation

protocol LocalizationDocumentDecoder: AnyObject {
    func decode(from string: String) throws -> LocalizationDocument
}

extension LocalizationImporter {
    public struct Request {
        public var documentSource: String
        
        public init(documentSource: String) {
            self.documentSource = documentSource
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
        let document = try documentDecoder.decode(from: request.documentSource)
        let sections = try document.toSections()
        
        return sections.reduce(into: [:]) { result, section in
            result[section.language] = plistGenerator.generate(from: section.items)
        }
    }
}
