import Foundation
import SwiftSyntax

public class EnumCaseIdentifierExtractor: SyntaxVisitor {
    private var result: String = ""
    
    public func extract(from node: EnumCaseDeclSyntax) -> String {
        defer { result = "" }
        walk(node)
        return result
    }
    
    public override func visitPost(_ node: EnumCaseElementSyntax) {
        result = node.name.text
    }
}
