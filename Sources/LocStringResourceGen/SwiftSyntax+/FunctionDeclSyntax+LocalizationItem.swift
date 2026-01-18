import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension FunctionDeclSyntax {
    init(_ item: LocalizationItem) {
        guard case let .method(methodName, parameters) = item.memberDeclaration else {
            preconditionFailure()
        }
        
        self = FunctionDeclSyntax(
            attributes: AttributeListSyntax(attributes: item.attributes),
            modifiers: [DeclModifierSyntax(name: .keyword(.static), trailingTrivia: .space)],
            name: TokenSyntax.identifier(methodName, leadingTrivia: .space),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    for (index, parameter) in parameters.enumerated() {
                        FunctionParameterSyntax(parameter)
                            .with(\.leadingTrivia, index == 0 ? Trivia() : .space)
                    }
                },
                returnClause: ReturnClauseSyntax(
                    leadingTrivia: .space,
                    type: IdentifierTypeSyntax(
                        leadingTrivia: .space,
                        name: TokenSyntax.identifier("Self")),
                    trailingTrivia: .space)),
            bodyBuilder: {
                IndentIncreaser.indent(
                    FunctionCallExprSyntax(item).with(\.leadingTrivia, .newline),
                    indentation: .spaces(4)
                )
                .with(\.trailingTrivia, .newline)
            }
        )
        .insetingNewlinesInSignatureIfNeeded()
        .with(\.leadingTrivia, Trivia(stringLiteral: item.commentsSourceCode))
    }
    
    private func insetingNewlinesInSignatureIfNeeded() -> FunctionDeclSyntax {
        let firstLine = description.components(separatedBy: .newlines)[0]
        let maxColumn = 100 - 4
        if firstLine.count <= maxColumn {
            return self
        }
        
        return with(\.signature.parameterClause.parameters, FunctionParameterListSyntax {
            for parameter in signature.parameterClause.parameters {
                parameter
                    .with(\.leadingTrivia, [.newlines(1), .spaces(4)])
                    .with(\.trailingTrivia, parameter.trailingComma == nil ? .newline : Trivia())
            }
        })
    }
}
