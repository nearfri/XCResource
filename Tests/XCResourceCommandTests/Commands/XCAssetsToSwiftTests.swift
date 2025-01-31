import Testing
import Foundation
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let colorKey = publicColorKey.replacingOccurrences(of: "public ", with: "")
    
    static let publicColorKey = """
    // This file was generated by xcresource.
    // Do Not Edit Directly!
    
    import Foundation
    
    public struct ColorKey: Hashable, Sendable {
        public let name: String
        public let bundle: Bundle
        
        public init(name: String, bundle: Bundle) {
            self.name = name
            self.bundle = bundle
        }
    }

    // MARK: - Media.xcassets

    extension ColorKey {
        public static let accentColor: ColorKey = .init(
            name: "AccentColor",
            bundle: Bundle.module)
        
        public static let battleshipGrey8: ColorKey = .init(
            name: "battleshipGrey8",
            bundle: Bundle.module)
        
        public static let battleshipGrey12: ColorKey = .init(
            name: "battleshipGrey12",
            bundle: Bundle.module)
        
        public static let black5: ColorKey = .init(
            name: "black5",
            bundle: Bundle.module)
        
        public static let blueBlue: ColorKey = .init(
            name: "blueBlue",
            bundle: Bundle.module)
        
        public static let blush: ColorKey = .init(
            name: "blush",
            bundle: Bundle.module)
        
        public static let brownGrey: ColorKey = .init(
            name: "brownGrey",
            bundle: Bundle.module)
        
        public static let white30: ColorKey = .init(
            name: "white30",
            bundle: Bundle.module)
        
        public static let wisteria: ColorKey = .init(
            name: "wisteria",
            bundle: Bundle.module)
    }
    
    """
}

@Suite struct XCAssetsToSwiftTests {
    @Test func runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let swiftFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: swiftFileURL)
        }
        
        // When
        try XCAssetsToSwift.runAsRoot(arguments: [
            "--xcassets-path", SampleData.assetURL().path,
            "--asset-type", "colorset",
            "--swift-file-path", swiftFileURL.path,
            "--resource-type-name", "ColorKey",
            "--bundle", "Bundle.module",
        ])
        
        // Then
        expectEqual(try String(contentsOf: swiftFileURL, encoding: .utf8), Fixture.colorKey)
    }
    
    @Test func runAsRoot_publicAccessLevel() throws {
        // Given
        let fm = FileManager.default
        
        let swiftFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: swiftFileURL)
        }
        
        // When
        try XCAssetsToSwift.runAsRoot(arguments: [
            "--xcassets-path", SampleData.assetURL().path,
            "--asset-type", "colorset",
            "--swift-file-path", swiftFileURL.path,
            "--resource-type-name", "ColorKey",
            "--bundle", "Bundle.module",
            "--access-level", "public",
        ])
        
        // Then
        expectEqual(try String(contentsOf: swiftFileURL, encoding: .utf8), Fixture.publicColorKey)
    }
}
