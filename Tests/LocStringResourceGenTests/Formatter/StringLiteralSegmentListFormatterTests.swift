import Testing
import SwiftSyntax
@testable import LocStringResourceGen

@Suite struct StringLiteralSegmentListFormatterTests {
    @Test func refactor_shortSingleLine() throws {
        // Given
        let string = "123456"
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 10, maxMultilineColumns: 10))
        
        // Then
        #expect(formattedSyntax.description == #""123456""#)
    }
    
    @Test func refactor_longSingleLine_convertToMultiline() throws {
        // Given
        let string = "123456"
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 5, maxMultilineColumns: 10))
        
        // Then
        #expect(formattedSyntax.description == #"""
            """
            123456
            """
            """#)
    }
    
    @Test func refactor_shortMultiline() throws {
        // Given
        let string = """
            12345689
            1234
            5678
            """
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 10, maxMultilineColumns: 10))
        
        // Then
        #expect(formattedSyntax.description == #"""
            """
            12345689
            1234
            5678
            """
            """#)
    }
    
    @Test func refactor_longMultiline_splitLineAtSpace() throws {
        // Given
        let string = """
            12345 67 89 1234 5678
            1234
            5678
            """
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 10, maxMultilineColumns: 10))
        
        // Then
        #expect(formattedSyntax.description == #"""
            """
            12345 67 \
            89 1234 \
            5678
            1234
            5678
            """
            """#)
    }
    
    @Test func refactor_longMultiline_longWord_dontSplitLine() throws {
        // Given
        let string = """
            12345678912345678
            1234
            5678
            """
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 10, maxMultilineColumns: 10))
        
        // Then
        #expect(formattedSyntax.description == #"""
            """
            12345678912345678
            1234
            5678
            """
            """#)
    }
    
    @Test func refactor_keepInterpolation() throws {
        // Given
        let string = #"""
            1234567 \(number, format: .number) 8912345
            1234
            5678
            """#
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 10, maxMultilineColumns: 10))
        
        // Then
        #expect(formattedSyntax.description == #"""
            """
            1234567 \
            \(number, format: .number)\
             8912345
            1234
            5678
            """
            """#)
    }
    
    @Test func refactor_escapingMarkdown() throws {
        // Given
        let string = #"""
            1234567 \(number, format: .number) 8912345
            ## H2
            **bold** _italic_ ~~strikethrough~~ `code`
            hello * world
            > blockquote
            1. ordered list
            - unordered list
            + unordered list
            [link](https://www.example.com)
            | table |
            <html>
            """#
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 100, maxMultilineColumns: 100),
            escapingMarkdown: true)
        
        // Then
        #expect(formattedSyntax.description == ###"""
            """
            1234567 \(number, format: .number) 8912345
            \## H2
            \*\*bold\*\* \_italic\_ \~\~strikethrough\~\~ \`code\`
            hello * world
            \> blockquote
            1\. ordered list
            \- unordered list
            \+ unordered list
            [link]\(https://www.example.com)
            \| table |
            \<html>
            """
            """###)
    }
}
