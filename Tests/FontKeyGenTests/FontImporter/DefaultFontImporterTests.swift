import Testing
import Foundation
@testable import FontKeyGen

private class FakeFontFinder: FontFinder {
    let paths: [String]
    
    init(paths: [String]) {
        self.paths = paths
    }
    
    override func find(at url: URL) throws -> [String] {
        return paths
    }
}

private extension Font {
    init(fontName: String, style: String, relativePath: String) {
        self.init(fontName: fontName,
                  familyName: fontName,
                  style: style,
                  relativePath: relativePath)
    }
}

private class FakeFontLoader: FontLoader {
    override func load(at path: String, relativeTo baseURL: URL) throws -> [Font] {
        let components = URL(filePath: path).lastPathComponent.split(separator: ".")
        let filename = String(components[0])
        let fileExtension = String(components[1])
        
        if fileExtension == "ttc" {
            return [
                Font(fontName: filename, style: "regular", relativePath: path),
                Font(fontName: filename, style: "bold", relativePath: path),
            ]
        } else {
            return [
                Font(fontName: filename, style: "regular", relativePath: path)
            ]
        }
    }
}

@Suite struct DefaultFontImporterTests {
    @Test func importFonts() throws {
        // Given
        let paths: [String] = [
            "Fonts/fontA.ttf",
            "Fonts/fontB.ttc",
        ]
        
        let resourcesURL = URL(filePath: "/Resources")
        
        let sut = DefaultFontImporter(fontFinder: FakeFontFinder(paths: paths),
                                      fontLoader: FakeFontLoader())
        
        // When
        let fonts = try sut.import(at: resourcesURL)
        
        // Then
        #expect(fonts == [
            Font(fontName: "fontA", style: "regular", relativePath: "Fonts/fontA.ttf"),
            Font(fontName: "fontB", style: "regular", relativePath: "Fonts/fontB.ttc"),
            Font(fontName: "fontB", style: "bold", relativePath: "Fonts/fontB.ttc"),
        ])
    }
}
