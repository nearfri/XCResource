import Foundation
import RegexBuilder
import SwiftSyntax

// SwiftSyntaxBuilder.Indenter가 multiline string literal을 처리하지 못하는 문제를 해결하기 위해 만들었다.

private extension Trivia {
    func indented(indentation: Trivia) -> Trivia {
        let mappedPieces = self.flatMap { (piece) -> [TriviaPiece] in
            if piece.isNewline {
                return [piece] + indentation.pieces
            } else {
                return [piece]
            }
        }
        return Trivia(pieces: mappedPieces)
    }
}

/// Adds a given amount of indentation after every newline in a syntax tree.
class IndentIncreaser: SyntaxRewriter {
    let indentation: Trivia
    
    init(indentation: Trivia) {
        self.indentation = indentation
        super.init(viewMode: .sourceAccurate)
    }
    
    /// Add `indentation` after all newlines in the syntax tree.
    public static func indent<SyntaxType: SyntaxProtocol>(
        _ node: SyntaxType,
        indentation: Trivia
    ) -> SyntaxType {
        return IndentIncreaser(indentation: indentation).rewrite(node).as(SyntaxType.self)!
    }
    
    public override func visit(_ token: TokenSyntax) -> TokenSyntax {
        return TokenSyntax(
            token.tokenKind,
            leadingTrivia: token.leadingTrivia.indented(indentation: indentation),
            trailingTrivia: token.trailingTrivia.indented(indentation: indentation),
            presence: token.presence
        )
    }
    
    public override func visit(_ node: StringSegmentSyntax) -> StringSegmentSyntax {
        guard node.description.contains(.newlineSequence) else {
            return node
        }
        return node.with(\.trailingTrivia, .init(pieces: node.trailingTrivia + indentation))
    }
}
