import XCTest
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let generatedFile = """
    // This file was generated by xcresource
    // Do Not Edit Directly!
    
    import Foundation
    
    public struct FileResource: Hashable, Sendable {
        public let relativePath: String
        public let bundle: Bundle
        
        public init(relativePath: String, bundle: Bundle) {
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
    
    extension FileResource {
        public enum SFNSDisplay {
            public static let sfnsDisplayBold: FileResource = .init(
                relativePath: "Fonts/SFNSDisplay/SFNSDisplay-Bold.otf",
                bundle: Bundle.module)
            
            public static let sfnsDisplayHeavy: FileResource = .init(
                relativePath: "Fonts/SFNSDisplay/SFNSDisplay-Heavy.otf",
                bundle: Bundle.module)
            
            public static let sfnsDisplayRegular: FileResource = .init(
                relativePath: "Fonts/SFNSDisplay/SFNSDisplay-Regular.otf",
                bundle: Bundle.module)
        }
        
        public static let avenir: FileResource = .init(
            relativePath: "Fonts/Avenir.ttc",
            bundle: Bundle.module)
        
        public static let zapfDingbats: FileResource = .init(
            relativePath: "Fonts/ZapfDingbats.ttf",
            bundle: Bundle.module)
    }
    
    """
}

final class FilesToSwiftTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let swiftFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: swiftFileURL)
        }
        
        // When
        try FilesToSwift.runAsRoot(arguments: [
            "--resources-path", SampleData.resourcesURL().path + "/Fonts",
            "--file-pattern", "(?i)\\.(otf|ttf|ttc)$",
            "--swift-path", swiftFileURL.path,
            "--key-type-name", "FileResource",
            "--preserve-relative-path",
            "--relative-path-prefix", "Fonts",
            "--bundle", "Bundle.module",
            "--access-level", "public",
        ])
        
        // Then
        let generatedKey = try String(contentsOf: swiftFileURL, encoding: .utf8)
        
        XCTAssertEqual(String(generatedKey), Fixture.generatedFile)
    }
}
