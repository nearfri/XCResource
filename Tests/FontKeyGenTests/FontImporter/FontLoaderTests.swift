import XCTest
import SampleData
@testable import FontKeyGen

final class FontLoaderTests: XCTestCase {
    func test_load_otf() throws {
        // Given
        let path = "SFNSDisplay/SFNSDisplay-Regular.otf"
        let baseURL = SampleData.fontDirectoryURL()
        let sut = FontLoader()
        
        // When
        let fonts = try sut.load(at: path, relativeTo: baseURL)
        
        // Then
        XCTAssertEqual(fonts, [
            Font(fontName: ".SFNSDisplay-Regular",
                 familyName: ".SF NS Display",
                 style: "Regular",
                 path: "SFNSDisplay/SFNSDisplay-Regular.otf")
        ])
    }
    
    func test_load_ttc() throws {
        // Given
        let path = "Avenir.ttc"
        let baseURL = SampleData.fontDirectoryURL()
        let sut = FontLoader()
        
        let expectedFonts: [Font] = [
            Font(fontName: "Avenir-Book",
                 familyName: "Avenir",
                 style: "Book",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-BookOblique",
                 familyName: "Avenir",
                 style: "Book Oblique",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-Black",
                 familyName: "Avenir",
                 style: "Black",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-BlackOblique",
                 familyName: "Avenir",
                 style: "Black Oblique",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-Heavy",
                 familyName: "Avenir",
                 style: "Heavy",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-HeavyOblique",
                 familyName: "Avenir",
                 style: "Heavy Oblique",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-Light",
                 familyName: "Avenir",
                 style: "Light",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-LightOblique",
                 familyName: "Avenir",
                 style: "Light Oblique",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-Medium",
                 familyName: "Avenir",
                 style: "Medium",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-MediumOblique",
                 familyName: "Avenir",
                 style: "Medium Oblique",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-Oblique",
                 familyName: "Avenir",
                 style: "Oblique",
                 path: "Avenir.ttc"),
            Font(fontName: "Avenir-Roman",
                 familyName: "Avenir",
                 style: "Roman",
                 path: "Avenir.ttc"),
        ]
        
        // When
        let actualFonts = try sut.load(at: path, relativeTo: baseURL)
        
        // Then
        XCTAssertEqual(actualFonts.count, expectedFonts.count)
        
        for (actualFont, expectedFont) in zip(actualFonts, expectedFonts) {
            XCTAssertEqual(actualFont, expectedFont)
        }
    }
}
