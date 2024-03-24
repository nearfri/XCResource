import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension StringLiteralExprSyntax {
    init(escapedContent: String) {
        if !escapedContent.contains("\n") {
            self.init(
                openingQuote: .stringQuoteToken(),
                segments: StringLiteralSegmentListSyntax {
                    StringSegmentSyntax(content: .stringSegment(escapedContent))
                },
                closingQuote: .stringQuoteToken())
        } else {
            let lines = escapedContent.split(separator: "\n", omittingEmptySubsequences: false)
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
