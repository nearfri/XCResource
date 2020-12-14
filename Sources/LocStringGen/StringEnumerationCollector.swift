import Foundation
import SwiftSyntax

class StringEnumerationCollector: SyntaxVisitor {
    private(set) var enumerations: [Enumeration<String>] = []
    private var currentEnumeraion: Enumeration<String> = .init(identifier: "", cases: [])
    
    override func visitPost(_ node: EnumDeclSyntax) {
        let id: TokenSyntax = node.identifier
        currentEnumeraion.identifier = id.text
        
        enumerations.append(currentEnumeraion)
        currentEnumeraion = .init(identifier: "", cases: [])
    }
    
    override func visitPost(_ node: EnumCaseDeclSyntax) {
        let comment = caseComment(in: node)
        let identifier = caseIdentifier(in: node)
        let rawValue = caseRawValue(in: node) ?? identifier
        
        currentEnumeraion.cases.append(
            .init(comment: comment, identifier: identifier, rawValue: rawValue)
        )
    }
    
    private func caseComment(in node: EnumCaseDeclSyntax) -> String? {
        let caseKeyword: TokenSyntax = node.caseKeyword
        let leadingTrivia: Trivia = caseKeyword.leadingTrivia
        
        let comments: [String] = leadingTrivia.reduce(into: []) { comments, piece in
            switch piece {
            case .docLineComment(var comment):
                comment.removeFirst("///".count)
                comments.append(comment)
            case .docBlockComment(var comment):
                comment.removeFirst("/**".count)
                comment.removeLast("*/".count)
                let lines = comment.split(separator: "\n").map(String.init)
                comments.append(contentsOf: lines)
            default:
                break
            }
        }
        
        let comment = comments
            .map({ $0.trimmingCharacters(in: .whitespaces) })
            .filter({ !$0.isEmpty })
            .joined(separator: " ")
        
        return !comment.isEmpty ? comment : nil
    }
    
    private func caseIdentifier(in node: EnumCaseDeclSyntax) -> String {
        let elements: EnumCaseElementListSyntax = node.elements
        
        precondition(elements.count == 1)
        let element: EnumCaseElementSyntax = elements[elements.startIndex]
        
        let identifier: TokenSyntax = element.identifier
        return identifier.text
    }
    
    private func caseRawValue(in node: EnumCaseDeclSyntax) -> String? {
        let elements: EnumCaseElementListSyntax = node.elements
        let element: EnumCaseElementSyntax = elements[elements.startIndex]

        guard let rawValue: InitializerClauseSyntax = element.rawValue,
              let stringRawValue = rawValue.value.as(StringLiteralExprSyntax.self)
        else { return nil }

        let stringSegments: StringLiteralSegmentsSyntax = stringRawValue.segments
        
        precondition(stringSegments.count == 1)
        let stringSegment: Syntax = stringSegments[stringSegments.startIndex]
        
        precondition(stringSegment.children.count == 1)
        let stringContent: Syntax = stringSegment.children[stringSegment.children.startIndex]
        
        return stringContent.as(TokenSyntax.self)!.text
    }
}
