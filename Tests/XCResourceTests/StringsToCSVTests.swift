import XCTest
import class Foundation.Bundle
import SampleData

private enum Seed {
    static let csvString = """
    Key,Comment,ko,en
    common_cancel,취소,취소,Cancel
    common_confirm,확인,확인,Confirm
    
    """
}

final class StringsToCSVTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: SampleData.localizationDirectoryURL(), to: resourcesURL)
        
        let csvFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: csvFileURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "strings2csv",
            "--resources-path", resourcesURL.path,
            "--development-localization", "ko",
            "--csv-path", csvFileURL.path,
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(try String(contentsOf: csvFileURL), Seed.csvString)
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
