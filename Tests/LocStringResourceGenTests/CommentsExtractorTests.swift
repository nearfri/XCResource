import Testing
import SwiftSyntax
@testable import LocStringResourceGen

@Suite struct CommentsExtractorTests {
    private let sut: CommentsExtractor = .init()
    
    @Test func extract_line() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .lineComment("// line comment"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        #expect(comments == [.line("line comment")])
    }
    
    @Test func extract_block() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .blockComment("/*\n block comment\n */"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        #expect(comments == [.block("block comment")])
    }
    
    @Test func extract_docLine() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .docLineComment("/// document line comment"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        #expect(comments == [.documentLine("document line comment")])
    }
    
    @Test func extract_docBlock() throws {
        // Given
        let trivia: Trivia = [
            .newlines(1),
            .docBlockComment("/**\n document block comment\n */"), .newlines(1),
        ]
        
        // When
        let comments = sut.comments(from: trivia)
        
        // Then
        #expect(comments == [.documentBlock("document block comment")])
    }
}
