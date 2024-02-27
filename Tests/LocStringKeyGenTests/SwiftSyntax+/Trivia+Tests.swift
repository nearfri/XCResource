import XCTest
import SwiftSyntax
import SwiftParser
@testable import LocStringKeyGen

final class TriviaTests: XCTestCase {
    // MARK: - trimmingEmptyLinePrefix
    
    func test_trimmingEmptyLinePrefix_withoutComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(2),
            .spaces(4), .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualTrimmed = sut.trimmingEmptyLinePrefix()
        
        // Then
        let expectedTrimmed = Trivia(pieces: [
            .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualTrimmed, expectedTrimmed)
    }
    
    func test_trimmingEmptyLinePrefix_withComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(2),
            .spaces(4), .newlines(1),
            .spaces(4), .docLineComment("/// Hello"), .newlines(1),
            .spaces(4), .docLineComment("/// World"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualTrimmed = sut.trimmingEmptyLinePrefix()
        
        // Then
        let expectedTrimmed = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .docLineComment("/// Hello"), .newlines(1),
            .spaces(4), .docLineComment("/// World"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualTrimmed, expectedTrimmed)
    }
    
    // MARK: - replacingDocumentComment
    
    func test_replacingDocumentComment_withDocComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .docLineComment("/// Confirm"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.replacingDocumentComment(with: "Cancel")
        
        // Then
        let expectedCommented = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .docLineComment("/// Cancel"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    func test_replacingDocumentComment_withDevCommentAndDocComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .docLineComment("/// Confirm"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.replacingDocumentComment(with: "Cancel")
        
        // Then
        let expectedCommented = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .docLineComment("/// Cancel"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    func test_replacingDocumentComment_withoutComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.replacingDocumentComment(with: "Cancel")
        
        // Then
        let expectedCommented = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .docLineComment("/// Cancel"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    func test_replacingDocumentComment_withDevComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.replacingDocumentComment(with: "Cancel")
        
        // Then
        let expectedCommented = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .docLineComment("/// Cancel"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    func test_replacingDocumentComment_withDevCommentAndDocComment_removeIfNilComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .docLineComment("/// Confirm"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.replacingDocumentComment(with: nil)
        
        // Then
        let expectedCommented = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    func test_replacingDocumentComment_withDevComment_removeIfNilComment() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.replacingDocumentComment(with: nil)
        
        // Then
        let expectedCommented = sut
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    // MARK: - addingLineComment
    
    func test_addingLineComment_insertAfterOriginalDeveloperComments() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.addingLineComment("Cancel")
        
        // Then
        let expectedCommented = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .lineComment("// Cancel"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    func test_addingLineComment_insertBeforeOriginalDocumentComments() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .docLineComment("/// Confirm"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.addingLineComment("Cancel")
        
        // Then
        let expectedCommented = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .lineComment("// Cancel"), .newlines(1),
            .spaces(4), .docLineComment("/// Confirm"), .newlines(1),
            .spaces(4),
        ])
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
    
    func test_addingLineComment_alreadyContaining_returnsOriginal() throws {
        // Given
        let sut = Trivia(pieces: [
            .newlines(1),
            .spaces(4), .newlines(1),
            .spaces(4), .lineComment("// Whatever"), .newlines(1),
            .spaces(4), .docLineComment("/// Confirm"), .newlines(1),
            .spaces(4),
        ])
        
        // When
        let actualCommented = sut.addingLineComment("Whatever")
        
        // Then
        let expectedCommented = sut
        
        XCTAssertEqual(actualCommented, expectedCommented)
    }
}
