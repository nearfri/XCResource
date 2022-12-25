import XCTest
@testable import FontKeyGen

private class FakeFontFinder: FontFinder {
    override func find(at url: URL) throws -> [String] {
        return [
            "fontA.ttf",
            "fontB.ttc",
        ]
    }
}

private class FakeFontLoader: FontLoader {
    override func load(at path: String, relativeTo baseURL: URL) throws -> [Font] {
        let components = path.split(separator: ".")
        let filename = String(components[0])
        let fileExtension = String(components[1])
        
        if fileExtension == "ttc" {
            return [
                Font(fontName: filename, familyName: filename, style: "regular", path: path),
                Font(fontName: filename, familyName: filename, style: "bold", path: path),
            ]
        } else {
            return [
                Font(fontName: filename, familyName: filename, style: "regular", path: path)
            ]
        }
    }
}

final class DefaultFontImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let sut = DefaultFontImporter(fontFinder: FakeFontFinder(),
                                      fontLoader: FakeFontLoader())
        
        // When
        let fonts = try sut.import(at: URL(fileURLWithPath: "/Fonts"))
        
        // Then
        XCTAssertEqual(fonts, [
            Font(fontName: "fontA", familyName: "fontA", style: "regular", path: "fontA.ttf"),
            Font(fontName: "fontB", familyName: "fontB", style: "regular", path: "fontB.ttc"),
            Font(fontName: "fontB", familyName: "fontB", style: "bold", path: "fontB.ttc"),
        ])
    }
}
