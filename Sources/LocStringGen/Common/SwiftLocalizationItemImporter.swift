import Foundation
import SwiftSyntax

class SwiftLocalizationItemImporter: LocalizationItemImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        let enumImporter = DefaultStringEnumerationImporter()
        let enumeration: Enumeration<String> = try enumImporter.import(at: url)
        
        return enumeration.cases.map { enumCase in
            let comment = enumCase.joinedDocumentComment
            return LocalizationItem(comment: comment, key: enumCase.rawValue, value: "")
        }
    }
}
