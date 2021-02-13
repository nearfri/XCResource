import Foundation
import SwiftSyntax

class SwiftSourceImporter: LocalizationItemImporter, StringEnumerationImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        let enumeration: Enumeration<String> = try self.import(at: url)
        
        return enumeration.cases.map { enumCase in
            let comment = enumCase.joinedDocumentComment
            return LocalizationItem(comment: comment, key: enumCase.rawValue, value: "")
        }
    }
    
    func `import`(at url: URL) throws -> Enumeration<String> {
        let syntaxTree: SourceFileSyntax = try SyntaxParser.parse(url)
        let enumCollector = StringEnumerationCollector()
        enumCollector.walk(syntaxTree)
        
        guard let enumeration = enumCollector.enumerations.first else {
            throw SwiftSourceImporterError.enumDoesNotExist(url)
        }
        
        return enumeration
    }
}

enum SwiftSourceImporterError: Error {
    case enumDoesNotExist(URL)
}
