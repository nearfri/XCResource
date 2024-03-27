import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension VariableDeclSyntax {
    init(_ item: LocalizationItem) {
        guard case .property(let propertyName) = item.memberDeclation else {
            preconditionFailure()
        }
        
        do {
            self = try VariableDeclSyntax("static var \(raw: propertyName): Self") {
                IndentIncreaser.indent(
                    FunctionCallExprSyntax(item).with(\.leadingTrivia, .newline),
                    indentation: .spaces(4)
                )
                .with(\.trailingTrivia, .newline)
            }
            .with(\.leadingTrivia, Trivia(stringLiteral: item.commentsSourceCode))
        } catch {
            preconditionFailure("\(error)")
        }
    }
}
