import XCTest
import class Foundation.Bundle
import SampleData

private enum Seed {
    static let defaultManifestFormat = """
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
    
    static let stringsToCSVManifestFormat = """
    {
        "commands": [
            {
                "commandName": "strings2csv",
                "resourcesPath": "%@",
                "tableName": "Localizable",
                "developmentLanguage": "en",
                "csvPath": "%@",
                "headerStyle": "long-ko",
                "writesBOM": false
            }
        ]
    }
    """
    
    static let csvToStringsManifestFormat = """
    {
        "commands": [
            {
                "commandName": "csv2strings",
                "csvPath": "%@",
                "headerStyle": "short",
                "resourcesPath": "%@",
                "tableName": "Translated",
                "includesEmptyFields": false
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
        
        let resourcesURL = makeUniqueURL()
        try fm.copyItem(at: SampleData.resourcesURL(), to: resourcesURL)
        
        let imageKeyFileURL = makeUniqueURL()
        let stringKeyFileURL = resourcesURL.appendingPathComponent("SourceCode/StringKey.swift")
        let stringFormFileURL = makeUniqueURL()
        
        let stringsURL = resourcesURL
            .appendingPathComponent("Localization/ko.lproj/Localizable.strings")
        let oldStrings = try String(contentsOf: stringsURL)
        
        let manifest = String(
            format: Seed.defaultManifestFormat,
            resourcesURL.appendingPathComponent("Media.xcassets").path,
            imageKeyFileURL.path,
            stringKeyFileURL.path,
            stringFormFileURL.path,
            stringKeyFileURL.path,
            resourcesURL.appendingPathComponent("Localization").path)
        
        let manifestFileURL = makeUniqueURL()
        try manifest.write(to: manifestFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
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
        
        XCTAssert(fm.fileExists(atPath: imageKeyFileURL.path))
        XCTAssert(fm.fileExists(atPath: stringFormFileURL.path))
        
        let newStrings = try String(contentsOf: stringsURL)
        XCTAssertNotEqual(newStrings, oldStrings)
    }
    
    func test_stringsToCSV() throws {
        let fm = FileManager.default
        
        let resourcesURL = SampleData.localizationDirectoryURL()
        let csvFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let manifest = String(
            format: Seed.stringsToCSVManifestFormat,
            resourcesURL.path,
            csvFileURL.path)
        
        let manifestFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try manifest.write(to: manifestFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: csvFileURL)
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
        
        XCTAssert(fm.fileExists(atPath: csvFileURL.path))
    }
    
    func test_csvToStrings() throws {
        let fm = FileManager.default
        
        let localizationURL = SampleData.localizationDirectoryURL()
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: localizationURL, to: resourcesURL)
        
        let csvFileURL = resourcesURL.appendingPathComponent("translation.csv")
        let stringsURL = resourcesURL.appendingPathComponent("ko.lproj/Translated.strings")
        XCTAssertFalse(fm.fileExists(atPath: stringsURL.path))
        
        let manifest = String(
            format: Seed.csvToStringsManifestFormat,
            csvFileURL.path,
            resourcesURL.path)
        
        let manifestFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try manifest.write(to: manifestFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
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
        
        XCTAssert(fm.fileExists(atPath: stringsURL.path))
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