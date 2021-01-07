import XCTest
import class Foundation.Bundle
import SampleData

final class XCAssetsToSwiftTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let swiftFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: swiftFileURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "xcassets2swift",
            "--xcassets-path", SampleData.assetURL().path,
            "--asset-type", "color",
            "--swift-path", swiftFileURL.path,
            "--swift-type-name", "ColorKey",
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(process.terminationStatus, 0)
        
        XCTAssertEqual(try String(contentsOf: swiftFileURL),
                       try String(contentsOf: SampleData.sourceCodeURL("ColorKey.swift")))
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
}
