import XCTest
import class Foundation.Bundle
import SampleData

final class generate_assetkeysTests: XCTestCase {
    func testExample() throws {
        let fm = FileManager.default
        
        let keyListFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: keyListFileURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("generate-keylist")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "--type-name", "StringKey",
            "--module-name", "SampleApp",
            "--input-file", SampleData.sourceCodeURL("StringKey.swift").path,
            "--output-file", keyListFileURL.path,
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(try String(contentsOf: keyListFileURL),
                       try String(contentsOf: SampleData.sourceCodeURL("AllStringKeys.swift")))
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
