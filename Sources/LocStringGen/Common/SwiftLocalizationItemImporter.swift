import Foundation
import SwiftSyntax

class SwiftLocalizationItemImporter: LocalizationItemImporter {
    private let enumerationImporter: StringEnumerationImporter
    
    init(enumerationImporter: StringEnumerationImporter) {
        self.enumerationImporter = enumerationImporter
    }
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
        let enumeration: Enumeration<String> = try enumerationImporter.import(at: url)
        
        return enumeration.cases.map { enumCase in
            LocalizationItem(
                id: enumCase.identifier,
                key: enumCase.rawValue,
                value: "",
                comment: enumCase.joinedDocumentComment)
        }
    }
}
