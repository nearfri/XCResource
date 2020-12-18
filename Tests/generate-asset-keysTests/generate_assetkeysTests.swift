import XCTest
import class Foundation.Bundle
import SampleData

final class generate_assetkeysTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let keyDeclFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let keyListFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: keyDeclFileURL)
            try? fm.removeItem(at: keyListFileURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("generate-asset-keys")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "--input-xcassets", SampleData.assetURL().path,
            "--asset-type", "color",
            "--key-type-name", "ColorKey",
            "--module-name", "SampleApp",
            "--key-decl-file", keyDeclFileURL.path,
            "--key-list-file", keyListFileURL.path,
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(try String(contentsOf: keyDeclFileURL),
                       try String(contentsOf: SampleData.sourceCodeURL("ColorKey.swift")))
        
        XCTAssertEqual(try String(contentsOf: keyListFileURL),
                       try String(contentsOf: SampleData.sourceCodeURL("AllColorKeys.swift")))
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
