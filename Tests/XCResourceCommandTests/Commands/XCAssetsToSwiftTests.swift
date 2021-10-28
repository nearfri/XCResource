import XCTest
@testable import XCResourceCommand
import SampleData

final class XCAssetsToSwiftTests: XCTestCase {
    func test_runAsRoot() throws {
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
            "--swift-path", swiftFileURL.path,
            "--swift-type-name", "ColorKey",
        ])
        
        // Then
        XCTAssertEqual(
            try String(contentsOf: swiftFileURL)
                .replacingOccurrences(of: "xctest", with: "xcresource"),
            try String(contentsOf: SampleData.sourceCodeURL("ColorKey.swift"))
        )
    }
}
