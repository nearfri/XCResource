import Foundation
import RegexBuilder
import SwiftSyntax

struct CommentsFormatter {
    enum CommentType {
        case localizationValue
        case translationComment
    }
    
    struct Context {
        var maxSingleLineColumns: Int = 100 - 31
        var maxMultilineColumns: Int = 100 - 16
    }
    
    static func comments(
        from string: String,
        type: CommentType,
        context: Context = .init()
    ) -> [String] {
        func lines(from str: String) -> [String] {
            return str
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: "\n", omittingEmptySubsequences: false)
                .map({ String($0).trimmingCharacters(in: .whitespaces) })
        }
        
        switch type {
        case .localizationValue:
            let formattedSyntax = StringLiteralFormatter.refactor(
                syntax: StringLiteralExprSyntax(contentLiteral: string),
                in: StringLiteralFormatter.Context(
                    maxSingleLineColumns: context.maxSingleLineColumns,
                    maxMultilineColumns: context.maxMultilineColumns),
                escapingMarkdown: true)
            
            var formatter = LocalizationValueFormatter(syntax: formattedSyntax.segments)
            
            return lines(from: formatter.refactor().description)
            
        case .translationComment:
            return lines(from: string)
        }
    }
}

private struct LocalizationValueFormatter {
    private let syntax: StringLiteralSegmentListSyntax
    
    private var segments: [StringLiteralSegmentListSyntax.Element] = []
    
    init(syntax: StringLiteralSegmentListSyntax) {
        self.syntax = syntax
    }
    
    mutating func refactor() -> StringLiteralSegmentListSyntax {
        for segment in syntax {
            switch segment {
            case .stringSegment(let stringSegment):
                append(stringSegment)
            case .expressionSegment(let expressionSegment):
                append(expressionSegment)
            }
        }
        
        return StringLiteralSegmentListSyntax(segments)
    }
    
    private mutating func append(_ stringSegment: StringSegmentSyntax) {
        var segment = stringSegment
        
        let text = segment.content.text
        
        if text.contains(.newlineSequence) {
            segment.content = .stringSegment(text.replacing(.newlineSequence, with: "\\\n"))
        } else if segment.trailingTrivia == .backslash + .newline {
            segment.trailingTrivia = Trivia()
            segment.content = .stringSegment(text + "\n")
        }
        
        segments.append(.stringSegment(segment))
    }
    
    private mutating func append(_ expressionSegment: ExpressionSegmentSyntax) {
        let text = expressionSegment.description.replacing(/["*\\]/) { match in
            "\\\(match.output)"
        }
        
        segments.append(.stringSegment(StringSegmentSyntax(content: .stringSegment(text))))
    }
}
