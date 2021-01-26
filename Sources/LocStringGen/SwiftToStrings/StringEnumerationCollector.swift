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
        let comments = caseComments(in: node)
        let identifier = caseIdentifier(in: node)
        let rawValue = caseRawValue(in: node) ?? identifier
        
        currentEnumeraion.cases.append(
            .init(comments: comments, identifier: identifier, rawValue: rawValue)
        )
    }
    
    private func caseComments(in node: EnumCaseDeclSyntax) -> [Comment] {
        let caseKeyword: TokenSyntax = node.caseKeyword
        let leadingTrivia: Trivia = caseKeyword.leadingTrivia
        
        func adjustLineCommentText<S: StringProtocol>(_ text: S) -> String {
            return text.trimmingCharacters(in: .whitespaces)
        }
        
        func adjustBlockCommentText(_ text: String) -> String {
            return text
                .split(separator: "\n")
                .map(adjustLineCommentText(_:))
                .joined(separator: "\n")
                .trimmingCharacters(in: .newlines)
        }
        
        return leadingTrivia.reduce(into: []) { comments, piece in
            switch piece {
            case .lineComment(var text):
                text.removeFirst("//".count)
                comments.append(.line(adjustLineCommentText(text)))
            case .blockComment(var text):
                text.removeFirst("/*".count)
                text.removeLast("*/".count)
                comments.append(.block(adjustBlockCommentText(text)))
            case .docLineComment(var text):
                text.removeFirst("///".count)
                comments.append(.documentLine(adjustLineCommentText(text)))
            case .docBlockComment(var text):
                text.removeFirst("/**".count)
                text.removeLast("*/".count)
                comments.append(.documentBlock(adjustBlockCommentText(text)))
            default:
                break
            }
        }
        .filter({ !$0.text.isEmpty })
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
