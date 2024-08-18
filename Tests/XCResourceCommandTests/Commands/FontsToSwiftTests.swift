import XCTest
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let generatedFilePrefix = """
    // This file was generated by xcresource
    // Do Not Edit Directly!
    
    import Foundation
    
    public struct FontKey: Hashable {
        public var fontName: String
        public var familyName: String
        public var style: String
        public var relativePath: String
        public var bundle: Bundle
        
        public init(
            fontName: String,
            familyName: String,
            style: String,
            relativePath: String,
            bundle: Bundle
        ) {
            self.fontName = fontName
            self.familyName = familyName
            self.style = style
            self.relativePath = relativePath
            self.bundle = bundle
        }
        
        public var url: URL {
            return URL(filePath: relativePath, relativeTo: bundle.resourceURL).standardizedFileURL
        }
        
        public var path: String {
            return url.path(percentEncoded: false)
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
            .sfNSDisplay_bold,
            .sfNSDisplay_heavy,
            .sfNSDisplay_regular,
            
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
            relativePath: "Fonts/Avenir.ttc",
            bundle: Bundle.main)
        
        static let avenir_bookOblique: FontKey = .init(
            fontName: "Avenir-BookOblique",
            familyName: "Avenir",
            style: "Book Oblique",
            relativePath: "Fonts/Avenir.ttc",
            bundle: Bundle.main)
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
            "--resources-path", SampleData.resourcesURL().path,
            "--swift-path", swiftFileURL.path,
            "--key-type-name", "FontKey",
            "--key-list-name", "all",
            "--preserve-relative-path",
            "--bundle", "Bundle.main",
            "--access-level", "public",
        ])
        
        // Then
        let generatedKey = try String(contentsOf: swiftFileURL)
        
        XCTAssertEqual(String(generatedKey.prefix(Fixture.generatedFilePrefix.count)),
                       Fixture.generatedFilePrefix)
    }
}
