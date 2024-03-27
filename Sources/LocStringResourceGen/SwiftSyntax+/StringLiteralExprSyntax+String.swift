import Foundation
import RegexBuilder
import SwiftSyntax
import SwiftParser

extension StringLiteralExprSyntax {
    init(contentLiteral: String) {
        let input = if contentLiteral.contains(.newlineSequence) {
            "\"\"\"\n\(contentLiteral)\n\"\"\""
        } else {
            "\"\(contentLiteral)\""
        }
        
        var parser = Parser(input)
        guard let syntax = StringLiteralExprSyntax(ExprSyntax.parse(from: &parser)) else {
            preconditionFailure()
        }
        
        self = syntax
    }
}
