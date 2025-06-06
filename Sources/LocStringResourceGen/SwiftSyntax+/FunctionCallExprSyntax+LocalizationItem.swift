import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension FunctionCallExprSyntax {
    init(_ item: LocalizationItem) {
        let spaces = String(repeating: " ", count: ".init(".count)
        let leadingTrivia = Trivia("\n\(spaces)")
        let indentInMultilineString = Trivia.spaces(Int(ceil(Double(spaces.count) / 4) * 4))
        
        self.init(callee: ExprSyntax(".init")) {
            LabeledExprSyntax(label: nil, expression: StringLiteralExprSyntax(content: item.key))
            
            LabeledExprSyntax(
                label: "defaultValue",
                expression: IndentIncreaser.indent(
                    StringLiteralFormatter.refactor(
                        syntax: item.defaultValueSyntax,
                        in: StringLiteralFormatter.Context()),
                    indentation: indentInMultilineString)
            )
            .with(\.leadingTrivia, leadingTrivia)
            
            if let table = item.table {
                LabeledExprSyntax(
                    label: "table",
                    expression: StringLiteralExprSyntax(content: table)
                )
                .with(\.leadingTrivia, leadingTrivia)
            }
            
            if item.bundle != .main {
                LabeledExprSyntax(label: "bundle", expression: ExprSyntax(item.bundle))
                    .with(\.leadingTrivia, leadingTrivia)
            }
            
            if let comment = item.translationComment?.escapedForStringLiteral {
                LabeledExprSyntax(
                    label: "comment",
                    expression: IndentIncreaser.indent(
                        StringLiteralFormatter.refactor(
                            syntax: StringLiteralExprSyntax(contentLiteral: comment),
                            in: StringLiteralFormatter.Context()),
                        indentation: indentInMultilineString)
                )
                .with(\.leadingTrivia, leadingTrivia)
            }
        }
    }
}
