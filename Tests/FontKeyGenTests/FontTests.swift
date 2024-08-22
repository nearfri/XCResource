import XCTest
@testable import FontKeyGen

final class FontTests: XCTestCase {
    func test_key_camelCased() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "", relativePath: "")
        
        // When
        let key = font.key
        
        // Then
        XCTAssertEqual(key, "arial")
    }
    
    func test_key_appendStyle() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "Regular", relativePath: "")
        
        // When
        let key = font.key
        
        // Then
        XCTAssertEqual(key, "arialRegular")
    }
}
