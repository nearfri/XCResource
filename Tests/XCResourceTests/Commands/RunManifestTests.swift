import XCTest
import class Foundation.Bundle
import SampleData

private enum Seed {
    static let manifestFormat = """
    {
        "commands": [
            {
                "commandName": "xcassets2swift",
                "xcassetsPaths": ["%@"],
                "assetTypes": ["imageset"],
                "swiftPath": "%@",
                "swiftTypeName": "ImageKey",
                "excludesTypeDeclation": false
            },
            {
                "commandName": "key2form",
                "keyFilePath": "%@",
                "formFilePath": "%@",
                "formTypeName": "StringForm",
                "excludesTypeDeclation": false,
                "issueReporter": "none"
            },
            {
                "commandName": "swift2strings",
                "swiftPath": "%@",
                "resourcesPath": "%@",
                "tableName": "Localizable",
                "languages": ["ko"],
                "valueStrategies": [
                    {
                        "language": "ko",
                        "strategy": "comment"
                    }
                ],
                "sortsByKey": false
            }
        ]
    }
    """
}

final class RunManifestTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        func makeUniqueURL() -> URL {
            return fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        }
        
        let resourceURL = makeUniqueURL()
        try fm.copyItem(at: SampleData.resourcesURL(), to: resourceURL)
        
        let imageKeyFileURL = makeUniqueURL()
        let stringKeyFileURL = resourceURL.appendingPathComponent("SourceCode/StringKey.swift")
        let stringFormFileURL = makeUniqueURL()
        
        let stringsURL = resourceURL
            .appendingPathComponent("Localization/ko.lproj/Localizable.strings")
        let oldStrings = try String(contentsOf: stringsURL)
        
        let manifest = String(
            format: Seed.manifestFormat,
            resourceURL.appendingPathComponent("Media.xcassets").path,
            imageKeyFileURL.path,
            stringKeyFileURL.path,
            stringFormFileURL.path,
            stringKeyFileURL.path,
            resourceURL.appendingPathComponent("Localization").path)
        
        let manifestFileURL = makeUniqueURL()
        try manifest.write(to: manifestFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourceURL)
            try? fm.removeItem(at: imageKeyFileURL)
            try? fm.removeItem(at: stringFormFileURL)
            try? fm.removeItem(at: manifestFileURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "run",
            "--manifest-path", manifestFileURL.path
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(process.terminationStatus, 0)
        
        let newStrings = try String(contentsOf: stringsURL)
        XCTAssert(fm.fileExists(atPath: imageKeyFileURL.path))
        XCTAssert(fm.fileExists(atPath: stringFormFileURL.path))
        XCTAssertNotEqual(newStrings, oldStrings)
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
