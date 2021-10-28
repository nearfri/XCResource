import XCTest
import class Foundation.Bundle
import SampleData

final class KeyToFormTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let formFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: formFileURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "key2form",
            "--key-file-path", SampleData.sourceCodeURL("StringKey.swift").path,
            "--form-file-path", formFileURL.path,
            "--form-type-name", "StringForm",
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(process.terminationStatus, 0)
        
        XCTAssertEqual(try String(contentsOf: formFileURL),
                       try String(contentsOf: SampleData.sourceCodeURL("StringForm.swift")))
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
