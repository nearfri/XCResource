import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension ExprSyntax {
    init(_ bundle: LocalizationItem.BundleDescription) {
        self = ExprSyntax(stringLiteral: bundle.rawValue)
    }
}
