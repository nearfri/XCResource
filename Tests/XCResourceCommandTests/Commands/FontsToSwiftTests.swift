import Testing
import Foundation
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let generatedFilePrefix = """
    // This file was generated by xcresource
    // Do Not Edit Directly!
    
    import Foundation
    
    public struct FontResource: Hashable, Sendable {
        public let fontName: String
        public let familyName: String
        public let style: String
        public let relativePath: String
        public let bundle: Bundle
        
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
    
    public extension FontResource {
        static let all: [FontResource] = [
            // Avenir
            .avenirBook,
            .avenirBookOblique,
            .avenirBlack,
            .avenirBlackOblique,
            .avenirHeavy,
            .avenirHeavyOblique,
            .avenirLight,
            .avenirLightOblique,
            .avenirMedium,
            .avenirMediumOblique,
            .avenirOblique,
            .avenirRoman,
            
            // .SF NS Display
            .sfNSDisplayBold,
            .sfNSDisplayHeavy,
            .sfNSDisplayRegular,
            
            // Zapf Dingbats
            .zapfDingbatsRegular,
        ]
    }
    
    public extension FontResource {
        // MARK: Avenir
        
        static let avenirBook: FontResource = .init(
            fontName: "Avenir-Book",
            familyName: "Avenir",
            style: "Book",
            relativePath: "Fonts/Avenir.ttc",
            bundle: Bundle.main)
        
        static let avenirBookOblique: FontResource = .init(
            fontName: "Avenir-BookOblique",
            familyName: "Avenir",
            style: "Book Oblique",
            relativePath: "Fonts/Avenir.ttc",
            bundle: Bundle.main)
    """
}

@Suite struct FontsToSwiftTests {
    @Test func runAsRoot() throws {
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
            "--resource-type-name", "FontResource",
            "--key-list-name", "all",
            "--preserve-relative-path",
            "--bundle", "Bundle.main",
            "--access-level", "public",
        ])
        
        // Then
        let generatedKey = try String(contentsOf: swiftFileURL, encoding: .utf8)
        
        expectEqual(String(generatedKey.prefix(Fixture.generatedFilePrefix.count)),
                    Fixture.generatedFilePrefix)
    }
}
