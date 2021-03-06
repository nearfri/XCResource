import XCTest
import class Foundation.Bundle
import SampleData

final class StringsToCSVTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let resourcesURL = SampleData.localizationDirectoryURL()
        let urlOfActualCSVFile = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let urlOfExpectedCSVFile = resourcesURL.appendingPathComponent("translation.csv")
        
        defer {
            try? fm.removeItem(at: urlOfActualCSVFile)
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
