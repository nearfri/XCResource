import Testing
import Foundation
import class Foundation.Bundle

private class BundleFinder {}

@Suite struct XCResourceCLITests {
    @Test func main() throws {
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["-h"]
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        
        try process.run()
        process.waitUntilExit() // Bottleneck
        
        #expect(process.terminationStatus == 0)
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        #expect(output.hasPrefix("OVERVIEW:"))
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
        let bundle = Bundle(for: BundleFinder.self)
        assert(bundle.bundlePath.hasSuffix(".xctest"))
        return bundle.bundleURL.deletingLastPathComponent()
    }
}
