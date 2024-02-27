import Foundation
import LocStringCore
import SwiftSyntax

public class SwiftLocalizationItemImporter: LocalizationItemImporter {
    private let enumerationImporter: StringEnumerationImporter
    
    public init(enumerationImporter: StringEnumerationImporter) {
        self.enumerationImporter = enumerationImporter
    }
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        let enumeration: Enumeration<String> = try enumerationImporter.import(at: url)
        
        return enumeration.cases.map { enumCase in
            LocalizationItem(
                id: enumCase.name,
                key: enumCase.rawValue,
                value: "",
                developerComments: enumCase.developerComments,
                comment: enumCase.joinedDocumentComment)
        }
    }
}
