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
            let comment = enumCase.joinedDocumentComment
            return LocalizationItem(comment: comment, key: enumCase.rawValue, value: "")
        }
    }
}
