import Foundation

protocol LocalizationSourceCodeRewriter: AnyObject {
    func rewrite(
        sourceCode: String,
        with items: [LocalizationItem],
        resourceTypeName: String
    ) -> String
}
