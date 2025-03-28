import Foundation
import RegexBuilder
import SwiftSyntax

struct StringLiteralFormatter {
    struct Context {
        var maxSingleLineColumns: Int = 100 - 31
        var maxMultilineColumns: Int = 100 - 16
    }
    
    static func refactor(
        syntax: StringLiteralExprSyntax,
        in context: Context,
        escapingMarkdown: Bool = false
    ) -> StringLiteralExprSyntax {
        var result = syntax
        
        var segmentListFormatter = StringLiteralSegmentListFormatter(
            syntax: result.segments,
            maxColumns: context.maxMultilineColumns,
            escapingMarkdown: escapingMarkdown)
        
        result.segments = segmentListFormatter.refactor()
        
        let string = result.segments.description
        if string.contains(.newlineSequence) || string.count > context.maxSingleLineColumns {
            result.openingQuote = .multilineStringQuoteToken(trailingTrivia: .newline)
            result.closingQuote = .multilineStringQuoteToken(leadingTrivia: .newline)
        }
        
        return result
    }
}

private struct StringLiteralSegmentListFormatter {
    private let syntax: StringLiteralSegmentListSyntax
    
    private let maxColumns: Int
    
    private let escapingMarkdown: Bool
    
    private var segments: [StringLiteralSegmentListSyntax.Element] = []
    
    private var currentColumns: Int = 0
    
    init(syntax: StringLiteralSegmentListSyntax, maxColumns: Int, escapingMarkdown: Bool) {
        self.syntax = syntax
        self.maxColumns = maxColumns
        self.escapingMarkdown = escapingMarkdown
    }
    
    mutating func refactor() -> StringLiteralSegmentListSyntax {
        for (index, segment) in syntax.enumerated() {
            switch segment {
            case .stringSegment(let stringSegment):
                append(stringSegment.trimmed, isLastSegment: index == syntax.count - 1)
            case .expressionSegment(let expressionSegment):
                append(expressionSegment.trimmed)
            }
        }
        
        return StringLiteralSegmentListSyntax(segments)
    }
    
    private mutating func append(_ stringSegment: StringSegmentSyntax, isLastSegment: Bool) {
        let text = stringSegment.content.text
        
        let words = if escapingMarkdown {
            text.addingMarkdownEscapes().words
        } else {
            text.words
        }
        
        for (index, word) in words.enumerated() {
            let endsWithNewline = word.last?.isNewline ?? false
            let wordLength = endsWithNewline ? word.count - 1 : word.count
            let isLastWord = index == words.count - 1
            let isEndOfLine = endsWithNewline || (isLastSegment && isLastWord)
            let columnThreshold = isEndOfLine ? maxColumns : maxColumns - 1
            
            if currentColumns != 0 && currentColumns + wordLength > columnThreshold {
                appendBackslashAndNewlineTrivia()
            }
            
            let wordSegment = StringSegmentSyntax(content: .stringSegment(word))
            segments.append(.stringSegment(wordSegment))
            currentColumns = endsWithNewline ? 0 : currentColumns + wordLength
        }
    }
    
    private mutating func append(_ expressionSegment: ExpressionSegmentSyntax) {
        if currentColumns + expressionSegment.description.count > maxColumns {
            appendBackslashAndNewlineTrivia()
        }
        
        segments.append(.expressionSegment(expressionSegment))
        currentColumns += expressionSegment.description.count
    }
    
    private mutating func appendBackslashAndNewlineTrivia() {
        let segment = StringSegmentSyntax(content: .stringSegment(""),
                                          trailingTrivia: .backslash + .newline)
        segments.append(.stringSegment(segment))
        currentColumns = 0
    }
}

private extension String {
    var words: [String] {
        return matches(of: /\S*\s*/).map({ String($0.output) })
    }
    
    func addingMarkdownEscapes() -> String {
        return replacing(/([*<_~])(\1*)/) { match in
            let prev = match.output.0.base[..<match.range.lowerBound].last ?? " "
            let next = match.output.0.base[match.range.upperBound...].first ?? " "
            if prev.isWhitespace && next.isWhitespace {
                return match.output.0
            }
            return "\\\(match.output.1)\(match.output.2.addingBackslashes())"
        }
        .replacing(/^( *)((#+ )|(>+)|([\-+*|] ))/) { match in
            "\(match.output.1)\\\(match.output.2)"
        }
        .replacing(/^( *)([1-9]+)(\. )/) { match in
            "\(match.output.1)\(match.output.2)\\\(match.output.3)"
        }
        .replacing(/[(`]/) { match in
            "\\\(match.output)"
        }
    }
}

private extension Substring {
    func addingBackslashes() -> String {
        return reduce(into: "") { partialResult, character in
            partialResult += "\\\(character)"
        }
    }
}
