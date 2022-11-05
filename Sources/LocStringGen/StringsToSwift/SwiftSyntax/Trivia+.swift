import Foundation
import SwiftSyntax

extension Trivia {
    private var pieces: [TriviaPiece] {
        reduce(into: [], { $0.append($1) })
    }
    
    func trimmingEmptyLinePrefix() -> Self {
        var pieces = pieces
        
        if pieces.isEmpty || !pieces[0].isNewlines {
            return self
        }
        
        let whitespaces = pieces.first(where: { $0.isHorizontalWhitespaces })
        let firstTextIndex = pieces.firstIndex(where: { $0.containsText })
        
        pieces.removeSubrange(0..<(firstTextIndex ?? pieces.endIndex))
        
        if let whitespaces {
            pieces.insert(whitespaces, at: 0)
        }
        
        pieces.insert(.newlines(1), at: 0)
        
        return Trivia(pieces: pieces)
    }
    
    func replacingDocumentComment(with comment: String?) -> Self {
        let docComment = comment.map({ TriviaPiece.docLineComment("/// \($0)") })
        let docComments = docComment.map({ [$0] }) ?? []
        
        var pieces = pieces
        
        let firstIndex = pieces.firstIndex(where: { $0.isDocumentComment })
        let lastIndex = pieces.lastIndex(where: { $0.isDocumentComment })
        
        if var firstIndex, var lastIndex {
            if docComments.isEmpty {
                if firstIndex > 0 && pieces[firstIndex - 1].isHorizontalWhitespaces {
                    firstIndex -= 1
                }
                if lastIndex + 1 < pieces.count && pieces[lastIndex + 1].isNewlines {
                    lastIndex += 1
                }
            }
            pieces.replaceSubrange(firstIndex...lastIndex, with: docComments)
        } else {
            if !docComments.isEmpty {
                let indent = pieces.last
                pieces.append(contentsOf: docComments + [.newlines(1)])
                indent.map({ pieces.append($0) })
            }
        }
        
        return Trivia(pieces: pieces)
    }
}
