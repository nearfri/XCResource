import Testing
import SampleData
@testable import FontKeyGen

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
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-BookOblique",
                 familyName: "Avenir",
                 style: "Book Oblique",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Black",
                 familyName: "Avenir",
                 style: "Black",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-BlackOblique",
                 familyName: "Avenir",
                 style: "Black Oblique",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Heavy",
                 familyName: "Avenir",
                 style: "Heavy",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-HeavyOblique",
                 familyName: "Avenir",
                 style: "Heavy Oblique",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Light",
                 familyName: "Avenir",
                 style: "Light",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-LightOblique",
                 familyName: "Avenir",
                 style: "Light Oblique",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Medium",
                 familyName: "Avenir",
                 style: "Medium",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-MediumOblique",
                 familyName: "Avenir",
                 style: "Medium Oblique",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Oblique",
                 familyName: "Avenir",
                 style: "Oblique",
                 relativePath: "Avenir.ttc"),
            Font(fontName: "Avenir-Roman",
                 familyName: "Avenir",
                 style: "Roman",
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
