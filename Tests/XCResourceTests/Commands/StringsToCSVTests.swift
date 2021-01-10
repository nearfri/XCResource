import XCTest
import class Foundation.Bundle
import SampleData

final class StringsToCSVTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let localizationURL = SampleData.localizationDirectoryURL()
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: localizationURL, to: resourcesURL)
        
        let urlOfActualCSVFile = resourcesURL.appendingPathComponent(UUID().uuidString)
        let urlOfExpectedCSVFile = localizationURL.appendingPathComponent("translation.csv")
        
        defer {
            try? fm.removeItem(at: resourcesURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "strings2csv",
            "--resources-path", resourcesURL.path,
            "--development-language", "ko",
            "--csv-path", urlOfActualCSVFile.path,
            "--header-style", "short",
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(process.terminationStatus, 0)
        
        XCTAssertEqual(try String(contentsOf: urlOfActualCSVFile),
                       try String(contentsOf: urlOfExpectedCSVFile))
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