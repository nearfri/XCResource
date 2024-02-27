import Foundation
import SwiftSyntax
import SwiftParser

public class SwiftStringEnumerationImporter: StringEnumerationImporter {
    public init() {}
    
    public func `import`(at url: URL) throws -> Enumeration<String> {
        let source = try String(contentsOf: url)
        let sourceFileNode: SourceFileSyntax = Parser.parse(source: source)
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
