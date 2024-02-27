import Foundation
import SwiftSyntax
import SwiftParser
import LocStringCore

class SwiftLocalizationSourceCodeRewriter: LocalizationSourceCodeRewriter {
    private let lineCommentForItem: (LocalizationItem) -> String?
    
    init(lineCommentForItem: @escaping (LocalizationItem) -> String?) {
        self.lineCommentForItem = lineCommentForItem
    }
    
    func applying(
        _ difference: LocalizationDifference,
        toSourceCode sourceCode: String
    ) throws -> String {
        let enumRewriter = StringEnumerationRewriter(
            difference: difference,
            lineCommentForLocalizationItem: lineCommentForItem)
        
        let sourceFileNode: SourceFileSyntax = Parser.parse(source: sourceCode)
        
        return enumRewriter.visit(sourceFileNode).description
    }
}
