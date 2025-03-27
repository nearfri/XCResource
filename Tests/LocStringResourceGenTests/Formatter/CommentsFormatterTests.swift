import Testing
@testable import LocStringResourceGen

@Suite struct CommentsFormatterTests {
    @Test func commentsFromContent_simpleLine() throws {
        // Given
        let string = """
            File will be deleted. This action cannot be undone.
            """
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            type: .localizationValue,
            context: CommentsFormatter.Context(maxSingleLineColumns: 80, maxMultilineColumns: 80))
        
        // Then
        #expect(comments == [
            "File will be deleted. This action cannot be undone.",
        ])
    }
    
    @Test func commentsFromContent_escapingMarkdown() throws {
        // Given
        let string = """
            File will be deleted. This **action** cannot be undone.
            """
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            type: .localizationValue,
            context: CommentsFormatter.Context(maxSingleLineColumns: 80, maxMultilineColumns: 80))
        
        // Then
        #expect(comments == [
            "File will be deleted. This \\*\\*action\\*\\* cannot be undone.",
        ])
    }
    
    @Test func commentsFromContent_atNewline_insertBackslash() throws {
        // Given
        let string = """
            File will be deleted.
            This action cannot be undone.
            """
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            type: .localizationValue,
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
            type: .localizationValue,
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
            \(count, specifier: "%5lld") files will be deleted.
            This action cannot be undone.
            """#
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            type: .localizationValue,
            context: CommentsFormatter.Context(maxSingleLineColumns: 80, maxMultilineColumns: 80))
        
        // Then
        #expect(comments == [
            "\\\\(count, specifier: \\\"%5lld\\\") files will be deleted.\\",
            "This action cannot be undone.",
        ])
    }
    
    @Test func commentsFromContent_translationComment_justSplitLines() throws {
        // Given
        let string = #"""
            Line breaks are entered with "Option + Return".
            
            - First item
            - Second item
            """#
        
        // When
        let comments = CommentsFormatter.comments(
            from: string,
            type: .translationComment)
        
        // Then
        #expect(comments == [
            "Line breaks are entered with \"Option + Return\".",
            "",
            "- First item",
            "- Second item",
        ])
    }
}
