import XCTest
@testable import LocStringResourceGen

final class CommentsFormatterTests: XCTestCase {
    func test_commentsFromContent_atNewline_insertBackslash() throws {
        // Given
        let string = """
            File will be deleted.
            This action cannot be undone.
            """
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            context: CommentsFormatter.Context(maxSingleLineColumns: 50, maxMultilineColumns: 50))
        
        // Then
        XCTAssertEqual(comments, [
            "File will be deleted.\\",
            "This action cannot be undone.",
        ])
    }
    
    func test_commentsFromContent_atWordWrap_dontInsertBackslash() throws {
        // Given
        let string = "Don't worry about me. Because I'm doing fine."
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            context: CommentsFormatter.Context(maxSingleLineColumns: 25, maxMultilineColumns: 25))
        
        // Then
        XCTAssertEqual(comments, [
            "Don't worry about me.",
            "Because I'm doing fine.",
        ])
    }
    
    func test_commentsFromContent_atInterpolation_insertBackslash() throws {
        // Given
        let string = #"""
            \(filename) will be deleted.
            This action cannot be undone.
            """#
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            context: CommentsFormatter.Context(maxSingleLineColumns: 50, maxMultilineColumns: 50))
        
        // Then
        XCTAssertEqual(comments, [
            "\\\\(filename) will be deleted.\\",
            "This action cannot be undone.",
        ])
    }
}
