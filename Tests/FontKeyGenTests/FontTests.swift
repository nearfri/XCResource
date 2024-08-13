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
        XCTAssertEqual(key, "arial_regular")
    }
    
    func test_key_hasSpace() throws {
        // Given
        let font = Font(fontName: "",
                        familyName: "Academy Engraved LET",
                        style: "",
                        relativePath: "")
        
        // When
        let key = font.key
        
        // Then
        XCTAssertEqual(key, "academyEngravedLET")
    }
    
    func test_key_hasPunctuation() throws {
        // Given
        let font = Font(fontName: "", familyName: ".SF NS Display", style: "", relativePath: "")
        
        // When
        let key = font.key
        
        // Then
        XCTAssertEqual(key, "sfnsDisplay")
    }
}
