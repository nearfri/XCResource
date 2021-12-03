import XCTest
import class Foundation.Bundle
import SampleData

private func toolchainPath() throws -> String {
    let developerPath = try Bash.execute(command: "xcode-select", arguments: ["-p"]).trimmed
    return "\(developerPath)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx"
}

private extension String {
    var trimmed: String { trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
}

private enum Bash {
    @discardableResult
    static func execute(command: String, arguments: [String] = []) throws -> String {
        let path = try execute(path: "/bin/bash", arguments: ["-lc", "which \(command)"]).trimmed
        return try execute(path: path, arguments: arguments)
    }
    
    @discardableResult
    static func execute(path: String, arguments: [String] = []) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        
        try process.run()
        process.waitUntilExit()
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
}

final class XCResourceCLITests: XCTestCase {
    let shouldTestMain: Bool = false // 너무 오래 걸리므로 생략
    
    func test_main() throws {
        guard shouldTestMain else { return }
        
        let toolchainPath = try toolchainPath()
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        try Bash.execute(command: "install_name_tool",
                         arguments: ["-add_rpath", toolchainPath, executableURL.path])
        defer {
            try! Bash.execute(command: "install_name_tool",
                              arguments: ["-delete_rpath", toolchainPath, executableURL.path])
        }
        
        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["-h"]
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        
        try process.run()
        process.waitUntilExit() // Bottleneck
        
        XCTAssertEqual(process.terminationStatus, 0)
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        XCTAssert(output.hasPrefix("OVERVIEW:"))
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
