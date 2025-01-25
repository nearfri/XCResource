import Testing
@testable import FontKeyGen

@Suite struct FontTests {
    @Test func id_camelCased() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "", relativePath: "")
        
        // When
        let id = font.id(transformingToLatin: false, strippingCombiningMarks: false)
        
        // Then
        #expect(id == "arial")
    }
    
    @Test func id_appendStyle() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial", style: "Regular", relativePath: "")
        
        // When
        let id = font.id(transformingToLatin: false, strippingCombiningMarks: false)
        
        // Then
        #expect(id == "arialRegular")
    }
    
    
    @Test func id_hangulToLatin() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial산토끼", style: "", relativePath: "")
        
        // When
        let id = font.id(transformingToLatin: true, strippingCombiningMarks: false)
        
        // Then
        #expect(id == "arialSantokki")
    }
    
    @Test func id_chineseToLatin() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial小野兔", style: "", relativePath: "")
        
        // When
        let id = font.id(transformingToLatin: true, strippingCombiningMarks: false)
        
        // Then
        #expect(id == "arialXiǎoYěTù")
    }
    
    @Test func id_strippingCombiningMarks() throws {
        // Given
        let font = Font(fontName: "", familyName: "café façade", style: "", relativePath: "")
        
        // When
        let id = font.id(transformingToLatin: false, strippingCombiningMarks: true)
        
        // Then
        #expect(id == "cafeFacade")
    }
    
    @Test func id_chineseToLatinAndStrippingCombiningMarks() throws {
        // Given
        let font = Font(fontName: "", familyName: "Arial小野兔", style: "", relativePath: "")
        
        // When
        let id = font.id(transformingToLatin: true, strippingCombiningMarks: true)
        
        // Then
        #expect(id == "arialXiaoYeTu")
    }
}
