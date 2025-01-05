import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeclSyntax {
    init(_ item: LocalizationItem) {
        switch item.memberDeclaration {
        case .property:
            self = DeclSyntax(VariableDeclSyntax(item))
        case .method:
            self = DeclSyntax(FunctionDeclSyntax(item))
        }
    }
}
