import Foundation
import SwiftSyntax
import SwiftSyntaxParser

class SwiftLocalizationSourceCodeRewriter: LocalizationSourceCodeRewriter {
    func applying(
        _ difference: LocalizationDifference,
        toSourceCode sourceCode: String
    ) throws -> String {
        let enumRewriter = StringEnumerationRewriter(difference: difference)
        
        let sourceFileNode: SourceFileSyntax = try SyntaxParser.parse(source: sourceCode)
        
        return enumRewriter.visit(sourceFileNode).description
    }
}
