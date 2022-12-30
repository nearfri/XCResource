import XCTest
@testable import LocSwiftCore

final class CommentTests: XCTestCase {
    func test_joinedDocumentText() {
        // Given
        let sut: [Comment] = [.documentLine("hello"), .documentLine("world")]
        
        // When
        let text = sut.joinedDocumentText
        
        // Then
        XCTAssertEqual(text, "hello world")
    }
    
    func test_joinedDocumentText_endsWithNewline_appendWithoutSpace() {
        // Given
        let sut: [Comment] = [.documentLine("hello\\n"), .documentLine("world")]
        
        // When
        let text = sut.joinedDocumentText
        
        // Then
        XCTAssertEqual(text, "hello\\nworld")
    }
}
