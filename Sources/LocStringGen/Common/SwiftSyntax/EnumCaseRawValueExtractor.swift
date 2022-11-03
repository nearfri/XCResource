import Foundation
import SwiftSyntax

class EnumCaseRawValueExtractor: SyntaxVisitor {
    private var result: String?
    
    func extract(from node: EnumCaseDeclSyntax) -> String? {
        defer { result = nil }
        walk(node)
        return result
    }
    
    override func visitPost(_ node: StringSegmentSyntax) {
        result = node.content.text
    }
}
