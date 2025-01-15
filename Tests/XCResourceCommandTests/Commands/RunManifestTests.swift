import Testing
import Foundation
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let generalManifestFormat = """
    {
        "commands": [
            {
                "commandName": "xcassets2swift",
                "xcassetsPaths": ["%@"],
                "assetTypes": ["imageset"], // comment
                "swiftPath": "%@",
                "keyTypeName": "ImageKey",
                "excludesTypeDeclaration": false
            },
            {
                "commandName": "key2form",
                "keyFilePath": "%@",
                "formFilePath": "%@",
                "formTypeName": "StringForm",
                "excludesTypeDeclaration": false,
                "issueReporter": "none"
            },
            {
                "commandName": "swift2strings",
                "swiftPath": "%@",
                "resourcesPath": "%@",
                "tableName": "Localizable",
                "languages": ["ko"],
                "configurationsByLanguage": {
                    "ko": {
                        "mergeStrategy": "comment",
                        "verifiesComments": false
                    }
                },
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
                "emptyEncoding": "#EMPTY",
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
                "emptyEncoding": "#EMPTY"
            }
        ]
    }
    """
}

@Suite struct RunManifestTests {
    @Test func runAsRoot_generalManifest() throws {
        // Given
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
        let oldStrings = try String(contentsOf: stringsURL, encoding: .utf8)
        
        let manifest = String(
            format: Fixture.generalManifestFormat,
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
        
        // When
        try RunManifest.runAsRoot(arguments: [
            "--manifest-path", manifestFileURL.path,
        ])
        
        // Then
        #expect(fm.fileExists(atPath: imageKeyFileURL.path))
        #expect(fm.fileExists(atPath: stringFormFileURL.path))
        
        let newStrings = try String(contentsOf: stringsURL, encoding: .utf8)
        #expect(newStrings != oldStrings)
    }
    
    @Test func runAsRoot_stringsToCSVManifest() throws {
        // Given
        let fm = FileManager.default
        
        let resourcesURL = SampleData.localizationDirectoryURL()
        let csvFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let manifest = String(
            format: Fixture.stringsToCSVManifestFormat,
            resourcesURL.path,
            csvFileURL.path)
        
        let manifestFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try manifest.write(to: manifestFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: csvFileURL)
            try? fm.removeItem(at: manifestFileURL)
        }
        
        // When
        try RunManifest.runAsRoot(arguments: [
            "--manifest-path", manifestFileURL.path,
        ])
        
        // Then
        #expect(fm.fileExists(atPath: csvFileURL.path))
    }
    
    @Test func runAsRoot_csvToStringsManifest() throws {
        // Given
        let fm = FileManager.default
        
        let localizationURL = SampleData.localizationDirectoryURL()
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: localizationURL, to: resourcesURL)
        
        let csvFileURL = resourcesURL.appendingPathComponent("localizations.csv")
        let stringsURL = resourcesURL.appendingPathComponent("ko.lproj/Translated.strings")
        #expect(!fm.fileExists(atPath: stringsURL.path))
        
        let manifest = String(
            format: Fixture.csvToStringsManifestFormat,
            csvFileURL.path,
            resourcesURL.path)
        
        let manifestFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try manifest.write(to: manifestFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: manifestFileURL)
        }
        
        // When
        try RunManifest.runAsRoot(arguments: [
            "--manifest-path", manifestFileURL.path,
        ])
        
        // Then
        #expect(fm.fileExists(atPath: stringsURL.path))
    }
}
