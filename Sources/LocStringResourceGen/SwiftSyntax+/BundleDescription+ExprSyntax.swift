import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension ExprSyntax {
    init(_ bundle: LocalizationItem.BundleDescription) {
        switch bundle {
        case .main:
            self = ExprSyntax(".main")
        case .atURL(let url):
            self = ExprSyntax(".atURL(\(raw: url))")
        case .forClass(let classType):
            self = ExprSyntax(".forClass(\(raw: classType))")
        }
    }
}
