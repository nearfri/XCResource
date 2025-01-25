import Testing
@testable import FontKeyGen

@Suite struct FontTests {
    @Test func key_camelCased() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "", relativePath: "")
        
        // When
        let key = font.identifier(transformingToLatin: false, strippingCombiningMarks: false)
        
        // Then
        #expect(key == "arial")
    }
    
    @Test func key_appendStyle() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "Regular", relativePath: "")
        
        // When
        let key = font.identifier(transformingToLatin: false, strippingCombiningMarks: false)
        
        // Then
        #expect(key == "arialRegular")
    }
    
    
    @Test func key_hangulToLatin() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial산토끼", style: "", relativePath: "")
        
        // When
        let key = font.identifier(transformingToLatin: true, strippingCombiningMarks: false)
        
        // Then
        #expect(key == "arialSantokki")
    }
    
    @Test func key_chineseToLatin() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial小野兔", style: "", relativePath: "")
        
        // When
        let key = font.identifier(transformingToLatin: true, strippingCombiningMarks: false)
        
        // Then
        #expect(key == "arialXiǎoYěTù")
    }
    
    @Test func key_strippingCombiningMarks() throws {
        // Given
        let font = Font(fontName: "", familyName: "café façade", style: "", relativePath: "")
        
        // When
        let key = font.identifier(transformingToLatin: false, strippingCombiningMarks: true)
        
        // Then
        #expect(key == "cafeFacade")
    }
    
    @Test func key_chineseToLatinAndStrippingCombiningMarks() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial小野兔", style: "", relativePath: "")
        
        // When
        let key = font.identifier(transformingToLatin: true, strippingCombiningMarks: true)
        
        // Then
        #expect(key == "arialXiaoYeTu")
    }
}
