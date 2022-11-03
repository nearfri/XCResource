import Foundation
import SwiftSyntax

class EnumCaseIdentifierExtractor: SyntaxVisitor {
    private var result: String = ""
    
    func extract(from node: EnumCaseDeclSyntax) -> String {
        defer { result = "" }
        walk(node)
        return result
    }
    
    override func visitPost(_ node: EnumCaseElementSyntax) {
        result = node.identifier.text
    }
}
