import Foundation
import SwiftSyntax

public class CommentsExtractor {
    public init() {}
    
    public func leadingComments(in node: SyntaxProtocol) -> [Comment] {
        return extract(from: node.leadingTrivia)
    }
    
    public func extract(from trivia: Trivia) -> [Comment] {
        return trivia.reduce(into: []) { comments, piece in
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
    
    private func adjustLineCommentText<S: StringProtocol>(_ text: S) -> String {
        return text.trimmingCharacters(in: .whitespaces)
    }
    
    private func adjustBlockCommentText(_ text: String) -> String {
        return text
            .split(separator: "\n")
            .map(adjustLineCommentText(_:))
            .joined(separator: "\n")
            .trimmingCharacters(in: .newlines)
    }
}
