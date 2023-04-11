import Foundation
import SwiftSyntax
import SwiftSyntaxParser
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
        
        let sourceFileNode: SourceFileSyntax = try SyntaxParser.parse(source: sourceCode)
        
        return enumRewriter.visit(sourceFileNode).description
    }
}
