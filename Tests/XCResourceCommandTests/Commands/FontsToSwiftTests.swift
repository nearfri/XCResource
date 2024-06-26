import XCTest
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let fontKeyPrefix = """
    // This file was generated by xcresource
    // Do Not Edit Directly!
    
    public struct FontKey: Hashable {
        public var fontName: String
        public var familyName: String
        public var style: String
        public var path: String
        
        public init(fontName: String, familyName: String, style: String, path: String) {
            self.fontName = fontName
            self.familyName = familyName
            self.style = style
            self.path = path
        }
    }
    
    public extension FontKey {
        static let all: [FontKey] = [
            // Avenir
            .avenir_book,
            .avenir_bookOblique,
            .avenir_black,
            .avenir_blackOblique,
            .avenir_heavy,
            .avenir_heavyOblique,
            .avenir_light,
            .avenir_lightOblique,
            .avenir_medium,
            .avenir_mediumOblique,
            .avenir_oblique,
            .avenir_roman,
            
            // .SF NS Display
            .sfnsDisplay_bold,
            .sfnsDisplay_heavy,
            .sfnsDisplay_regular,
            
            // Zapf Dingbats
            .zapfDingbats_regular,
        ]
    }
    
    public extension FontKey {
        // MARK: Avenir
        
        static let avenir_book: FontKey = .init(
            fontName: "Avenir-Book",
            familyName: "Avenir",
            style: "Book",
            path: "Avenir.ttc")
        
        static let avenir_bookOblique: FontKey = .init(
            fontName: "Avenir-BookOblique",
            familyName: "Avenir",
            style: "Book Oblique",
            path: "Avenir.ttc")
    """
}

final class FontsToSwiftTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let swiftFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: swiftFileURL)
        }
        
        // When
        try FontsToSwift.runAsRoot(arguments: [
            "--fonts-path", SampleData.fontDirectoryURL().path,
            "--swift-path", swiftFileURL.path,
            "--key-type-name", "FontKey",
            "--access-level", "public",
        ])
        
        // Then
        let generatedKey = try String(contentsOf: swiftFileURL)
        
        XCTAssertEqual(String(generatedKey.prefix(Fixture.fontKeyPrefix.count)),
                       Fixture.fontKeyPrefix)
    }
}
