import Foundation
import SwiftSyntax

extension TriviaPiece {
    var isHorizontalWhitespaces: Bool {
        switch self {
        case .spaces, .tabs:
            return true
        default:
            return false
        }
    }
    
    var isNewlines: Bool {
        switch self {
        case .newlines, .carriageReturns, .carriageReturnLineFeeds:
            return true
        default:
            return false
        }
    }
    
    var isDocumentComment: Bool {
        switch self {
        case .docLineComment, .docBlockComment:
            return true
        default:
            return false
        }
    }
    
    var containsText: Bool {
        switch self {
        case .lineComment, .blockComment, .docLineComment, .docBlockComment:
            return true
        case .unexpectedText, .shebang:
            return true
        default:
            return false
        }
    }
}
