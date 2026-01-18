import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension AttributeListSyntax {
    init(attributes: [String]) {
        self.init {
            for attribute in attributes {
                AttributeSyntax(stringLiteral: attribute)
                    .with(\.trailingTrivia, .newline)
            }
        }
    }
}
