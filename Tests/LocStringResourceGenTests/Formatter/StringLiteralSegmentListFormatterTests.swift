import XCTest
import SwiftSyntax
@testable import LocStringResourceGen

final class StringLiteralSegmentListFormatterTests: XCTestCase {
    func test_refactor_shortSingleLine() throws {
        // Given
        let string = "123456"
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 10, maxMultilineColumns: 10))
        
        // Then
        XCTAssertEqual(formattedSyntax.description, #""123456""#)
    }
    
    func test_refactor_longSingleLine_convertToMultiline() throws {
        // Given
        let string = "123456"
        let syntax = StringLiteralExprSyntax(contentLiteral: string)
        
        // When
        let formattedSyntax = StringLiteralFormatter.refactor(
            syntax: syntax,
            in: .init(maxSingleLineColumns: 5, maxMultilineColumns: 10))
        
        // Then
        XCTAssertEqual(formattedSyntax.description, #"""
            """
            123456
            """
            """#)
    }
    
    func test_refactor_shortMultiline() throws {
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
        XCTAssertEqual(formattedSyntax.description, #"""
            """
            12345689
            1234
            5678
            """
            """#)
    }
    
    func test_refactor_longMultiline_splitLineAtSpace() throws {
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
        XCTAssertEqual(formattedSyntax.description, #"""
            """
            12345 67 \
            89 1234 \
            5678
            1234
            5678
            """
            """#)
    }
    
    func test_refactor_longMultiline_longWord_dontSplitLine() throws {
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
        XCTAssertEqual(formattedSyntax.description, #"""
            """
            12345678912345678
            1234
            5678
            """
            """#)
    }
    
    func test_refactor_keepInterpolation() throws {
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
        XCTAssertEqual(formattedSyntax.description, #"""
            """
            1234567 \
            \(number, format: .number)\
             8912345
            1234
            5678
            """
            """#)
    }
}
