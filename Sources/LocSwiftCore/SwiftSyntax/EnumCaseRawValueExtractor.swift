import Foundation
import SwiftSyntax

public class EnumCaseRawValueExtractor: SyntaxVisitor {
    private var result: String?
    
    public func extract(from node: EnumCaseDeclSyntax) -> String? {
        defer { result = nil }
        walk(node)
        return result
    }
    
    public override func visitPost(_ node: StringSegmentSyntax) {
        result = node.content.text
    }
}
