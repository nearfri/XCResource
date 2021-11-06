import Foundation
import SwiftSyntax

class DefaultStringEnumerationImporter: StringEnumerationImporter {
    func `import`(at url: URL) throws -> Enumeration<String> {
        let syntaxTree: SourceFileSyntax = try SyntaxParser.parse(url)
        let enumCollector = StringEnumerationCollector()
        enumCollector.walk(syntaxTree)
        
        guard let enumeration = enumCollector.enumerations.first else {
            throw DefaultStringEnumerationImporterError.enumDoesNotExist(url)
        }
        
        return enumeration
    }
}

enum DefaultStringEnumerationImporterError: Error {
    case enumDoesNotExist(URL)
}
