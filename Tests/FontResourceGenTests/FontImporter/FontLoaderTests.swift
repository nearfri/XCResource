import Testing
import SampleData
@testable import FontResourceGen

@Suite struct FontLoaderTests {
    @Test func load_otf() throws {
        // Given
        let path = "SFNSDisplay/SFNSDisplay-Regular.otf"
        let baseURL = SampleData.fontDirectoryURL()
        let sut = FontLoader()
        
        // When
        let fonts = try sut.load(at: path, relativeTo: baseURL)
        
        // Then
        #expect(fonts == [
            Font(fontName: ".SFNSDisplay-Regular",
                 familyName: ".SF NS Display",
                 style: "Regular",
                 symbolicTraits: [],
                 relativePath: "SFNSDisplay/SFNSDisplay-Regular.otf")
        ])
    }
    
    @Test func load_ttc() throws {
        // Given
        let path = "Avenir.ttc"
        let baseURL = SampleData.fontDirectoryURL()
        let sut = FontLoader()
        
        let expectedFonts: [Font] = [
            Font(fontName: "Avenir-Book",
                 familyName: "Avenir",
                 style: "Book",
                 symbolicTraits: [],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-BookOblique",
                 familyName: "Avenir",
                 style: "Book Oblique",
                 symbolicTraits: [.traitItalic],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Black",
                 familyName: "Avenir",
                 style: "Black",
                 symbolicTraits: [.traitBold],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-BlackOblique",
                 familyName: "Avenir",
                 style: "Black Oblique",
                 symbolicTraits: [.traitItalic, .traitBold],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Heavy",
                 familyName: "Avenir",
                 style: "Heavy",
                 symbolicTraits: [.traitBold],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-HeavyOblique",
                 familyName: "Avenir",
                 style: "Heavy Oblique",
                 symbolicTraits: [.traitItalic, .traitBold],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Light",
                 familyName: "Avenir",
                 style: "Light",
                 symbolicTraits: [],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-LightOblique",
                 familyName: "Avenir",
                 style: "Light Oblique",
                 symbolicTraits: [.traitItalic],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Medium",
                 familyName: "Avenir",
                 style: "Medium",
                 symbolicTraits: [],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-MediumOblique",
                 familyName: "Avenir",
                 style: "Medium Oblique",
                 symbolicTraits: [.traitItalic],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Oblique",
                 familyName: "Avenir",
                 style: "Oblique",
                 symbolicTraits: [.traitItalic],
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Roman",
                 familyName: "Avenir",
                 style: "Roman",
                 symbolicTraits: [],
                 relativePath: "Avenir.ttc"),
        ]
        
        // When
        let actualFonts = try sut.load(at: path, relativeTo: baseURL)
        
        // Then
        #expect(actualFonts.count == expectedFonts.count)
        
        for (actualFont, expectedFont) in zip(actualFonts, expectedFonts) {
            #expect(actualFont == expectedFont)
        }
    }
}
