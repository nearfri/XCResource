import XCTest
import SwiftSyntax
@testable import LocStringResourceGen

final class CommentsExtractorTests: XCTestCase {
    private let sut: CommentsExtractor = .init()
    
    func test_extract_line() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .lineComment("// line comment"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        XCTAssertEqual(comments, [.line("line comment")])
    }
    
    func test_extract_block() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .blockComment("/*\n block comment\n */"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        XCTAssertEqual(comments, [.block("block comment")])
    }
    
    func test_extract_docLine() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .docLineComment("/// document line comment"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        XCTAssertEqual(comments, [.documentLine("document line comment")])
    }
    
    func test_extract_docBlock() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .docBlockComment("/**\n document block comment\n */"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        XCTAssertEqual(comments, [.documentBlock("document block comment")])
    }
}
