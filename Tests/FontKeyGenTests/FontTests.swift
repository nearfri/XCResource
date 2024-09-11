import XCTest
@testable import FontKeyGen

final class FontTests: XCTestCase {
    func test_key_camelCased() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "", relativePath: "")
        
        // When
        let key = font.key(asLatin: false, strippingCombiningMarks: false)
        
        // Then
        XCTAssertEqual(key, "arial")
    }
    
    func test_key_appendStyle() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "Regular", relativePath: "")
        
        // When
        let key = font.key(asLatin: false, strippingCombiningMarks: false)
        
        // Then
        XCTAssertEqual(key, "arialRegular")
    }
    
    
    func test_key_hangulToLatin() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial산토끼", style: "", relativePath: "")
        
        // When
        let key = font.key(asLatin: true, strippingCombiningMarks: false)
        
        // Then
        XCTAssertEqual(key, "arialSantokki")
    }
    
    func test_key_chineseToLatin() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial小野兔", style: "", relativePath: "")
        
        // When
        let key = font.key(asLatin: true, strippingCombiningMarks: false)
        
        // Then
        XCTAssertEqual(key, "arialXiǎoYěTù")
    }
    
    func test_key_strippingCombiningMarks() throws {
        // Given
        let font = Font(fontName: "", familyName: "café façade", style: "", relativePath: "")
        
        // When
        let key = font.key(asLatin: false, strippingCombiningMarks: true)
        
        // Then
        XCTAssertEqual(key, "cafeFacade")
    }
    
    func test_key_chineseToLatinAndStrippingCombiningMarks() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial小野兔", style: "", relativePath: "")
        
        // When
        let key = font.key(asLatin: true, strippingCombiningMarks: true)
        
        // Then
        XCTAssertEqual(key, "arialXiaoYeTu")
    }
}
