import Foundation
import SwiftSyntax

class LocalizationSourceFetcher: LocalizationItemFetcher {
    func fetch(at url: URL) throws -> [LocalizationItem] {
        let syntaxTree: SourceFileSyntax = try SyntaxParser.parse(url)
        let enumCollector = StringEnumerationCollector()
        enumCollector.walk(syntaxTree)
        
        guard let enumeration = enumCollector.enumerations.first else {
            throw SourceFetcherError.enumDoesNotExist(url)
        }
        
        return enumeration.cases.map { enumCase in
            .init(comment: enumCase.comment, key: enumCase.rawValue, value: "")
        }
    }
}

enum SourceFetcherError: Error {
    case enumDoesNotExist(URL)
}
