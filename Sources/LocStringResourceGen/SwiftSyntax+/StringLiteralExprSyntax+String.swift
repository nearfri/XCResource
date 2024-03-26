import Foundation
import RegexBuilder
import SwiftSyntax
import SwiftSyntaxBuilder

extension StringLiteralExprSyntax {
    init(escapedContent: String) {
        if !escapedContent.contains(.newlineSequence) {
            self.init(
                openingQuote: .stringQuoteToken(),
                segments: StringLiteralSegmentListSyntax {
                    StringSegmentSyntax(content: .stringSegment(escapedContent))
                },
                closingQuote: .stringQuoteToken())
        } else {
            let lines = escapedContent.split(omittingEmptySubsequences: false,
                                             whereSeparator: { $0.isNewline })
            self.init(
                openingQuote: .multilineStringQuoteToken(),
                segments: StringLiteralSegmentListSyntax {
                    for line in lines {
                        StringSegmentSyntax(
                            leadingTrivia: .newline,
                            content: .stringSegment(String(line)))
                    }
                },
                closingQuote: .multilineStringQuoteToken(leadingTrivia: .newline))
        }
    }
}
