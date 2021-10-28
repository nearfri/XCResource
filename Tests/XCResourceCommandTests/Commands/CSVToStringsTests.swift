import XCTest
import class Foundation.Bundle
import SampleData

final class CSVToStringsTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let localizationURL = SampleData.localizationDirectoryURL()
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: localizationURL, to: resourcesURL)
        
        let csvFileURL = resourcesURL.appendingPathComponent("translation.csv")
        
        defer {
            try? fm.removeItem(at: resourcesURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "csv2strings",
            "--csv-path", csvFileURL.path,
            "--header-style", "short",
            "--resources-path", resourcesURL.path,
            "--table-name", "Translated",
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(process.terminationStatus, 0)
        
        let actualEnURL = resourcesURL.appendingPathComponent("en.lproj/Translated.strings")
        let actualKoURL = resourcesURL.appendingPathComponent("ko.lproj/Translated.strings")
        
        let expectedEnURL = resourcesURL.appendingPathComponent("en.lproj/Localizable.strings")
        let expectedKoURL = resourcesURL.appendingPathComponent("ko.lproj/Localizable.strings")
        
        XCTAssertEqual(try String(contentsOf: actualEnURL), try String(contentsOf: expectedEnURL))
        XCTAssertEqual(try String(contentsOf: actualKoURL), try String(contentsOf: expectedKoURL))
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
