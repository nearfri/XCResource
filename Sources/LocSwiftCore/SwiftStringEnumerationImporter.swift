import Foundation
import SwiftSyntax
import SwiftSyntaxParser

public class SwiftStringEnumerationImporter: StringEnumerationImporter {
    public init() {}
    
    public func `import`(at url: URL) throws -> Enumeration<String> {
        let sourceFileNode: SourceFileSyntax = try SyntaxParser.parse(url)
        let enumCollector = StringEnumerationCollector(viewMode: .sourceAccurate)
        enumCollector.walk(sourceFileNode)
        
        guard let enumeration = enumCollector.enumerations.first else {
            throw DefaultStringEnumerationImporterError.enumDoesNotExist(url)
        }
        
        return enumeration
    }
}

public enum DefaultStringEnumerationImporterError: Error {
    case enumDoesNotExist(URL)
}
