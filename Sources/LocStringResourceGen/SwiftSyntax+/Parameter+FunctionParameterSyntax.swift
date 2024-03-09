import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension FunctionParameterSyntax {
    init(_ parameter: LocalizationItem.Parameter) {
        self.init(
            firstName: .identifier(parameter.firstName),
            secondName: parameter.secondName.map {
                .identifier($0).with(\.leadingTrivia, .space)
            },
            type: IdentifierTypeSyntax(
                leadingTrivia: .space,
                name: .identifier(parameter.type)),
            defaultValue: parameter.defaultValue.flatMap {
                InitializerClauseSyntax(
                    leadingTrivia: .space,
                    value: ExprSyntax(stringLiteral: $0).with(\.leadingTrivia, .space))
            })
    }
}
