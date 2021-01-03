import Foundation
import SwiftSyntax

class SwiftSourceImporter: LocalizationItemImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        let syntaxTree: SourceFileSyntax = try SyntaxParser.parse(url)
        let enumCollector = StringEnumerationCollector()
        enumCollector.walk(syntaxTree)
        
        guard let enumeration = enumCollector.enumerations.first else {
            throw SourceImporterError.enumDoesNotExist(url)
        }
        
        return enumeration.cases.map { enumCase in
            .init(comment: enumCase.comment, key: enumCase.rawValue, value: "")
        }
    }
}

enum SourceImporterError: Error {
    case enumDoesNotExist(URL)
}
