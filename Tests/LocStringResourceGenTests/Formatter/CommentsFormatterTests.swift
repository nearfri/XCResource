import Testing
@testable import LocStringResourceGen

@Suite struct CommentsFormatterTests {
    @Test func commentsFromContent_atNewline_insertBackslash() throws {
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
        #expect(comments == [
            "File will be deleted.\\",
            "This action cannot be undone.",
        ])
    }
    
    @Test func commentsFromContent_atWordWrap_dontInsertBackslash() throws {
        // Given
        let string = "Don't worry about me. Because I'm doing fine."
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            context: CommentsFormatter.Context(maxSingleLineColumns: 25, maxMultilineColumns: 25))
        
        // Then
        #expect(comments == [
            "Don't worry about me.",
            "Because I'm doing fine.",
        ])
    }
    
    @Test func commentsFromContent_atInterpolation_insertBackslash() throws {
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
        #expect(comments == [
            "\\\\(filename) will be deleted.\\",
            "This action cannot be undone.",
        ])
    }
}
