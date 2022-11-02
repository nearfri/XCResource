import Foundation
import SwiftSyntax
import SwiftSyntaxParser

class SwiftStringEnumerationImporter: StringEnumerationImporter {
    func `import`(at url: URL) throws -> Enumeration<String> {
        let sourceFileNode: SourceFileSyntax = try SyntaxParser.parse(url)
        let enumCollector = StringEnumerationCollector()
        enumCollector.walk(sourceFileNode)
        
        guard let enumeration = enumCollector.enumerations.first else {
            throw DefaultStringEnumerationImporterError.enumDoesNotExist(url)
        }
        
        return enumeration
    }
}

enum DefaultStringEnumerationImporterError: Error {
    case enumDoesNotExist(URL)
}
