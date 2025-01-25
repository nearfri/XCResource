import Testing
import Foundation
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let generalConfigurationFormat = """
    {
        "commands": [
            {
                "commandName": "xcassets2swift",
                "xcassetsPaths": ["%@"],
                "assetTypes": ["imageset"], // comment
                "swiftPath": "%@",
                "resourceTypeName": "ImageKey",
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
    
    static let stringsToCSVConfigurationFormat = """
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
    
    static let csvToStringsConfigurationFormat = """
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

@Suite struct Config_RunTests {
    @Test func runAsRoot_generalConfiguration() throws {
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
        
        let configuration = String(
            format: Fixture.generalConfigurationFormat,
            resourcesURL.appendingPathComponent("Media.xcassets").path,
            imageKeyFileURL.path,
            stringKeyFileURL.path,
            stringFormFileURL.path,
            stringKeyFileURL.path,
            resourcesURL.appendingPathComponent("Localization").path)
        
        let configurationFileURL = makeUniqueURL()
        try configuration.write(to: configurationFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: imageKeyFileURL)
            try? fm.removeItem(at: stringFormFileURL)
            try? fm.removeItem(at: configurationFileURL)
        }
        
        // When
        try Config.Run.runAsRoot(arguments: [
            "--configuration-path", configurationFileURL.path,
        ])
        
        // Then
        #expect(fm.fileExists(atPath: imageKeyFileURL.path))
        #expect(fm.fileExists(atPath: stringFormFileURL.path))
        
        let newStrings = try String(contentsOf: stringsURL, encoding: .utf8)
        #expect(newStrings != oldStrings)
    }
    
    @Test func runAsRoot_stringsToCSVConfiguration() throws {
        // Given
        let fm = FileManager.default
        
        let resourcesURL = SampleData.localizationDirectoryURL()
        let csvFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let configuration = String(
            format: Fixture.stringsToCSVConfigurationFormat,
            resourcesURL.path,
            csvFileURL.path)
        
        let configurationFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try configuration.write(to: configurationFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: csvFileURL)
            try? fm.removeItem(at: configurationFileURL)
        }
        
        // When
        try Config.Run.runAsRoot(arguments: [
            "--configuration-path", configurationFileURL.path,
        ])
        
        // Then
        #expect(fm.fileExists(atPath: csvFileURL.path))
    }
    
    @Test func runAsRoot_csvToStringsConfiguration() throws {
        // Given
        let fm = FileManager.default
        
        let localizationURL = SampleData.localizationDirectoryURL()
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: localizationURL, to: resourcesURL)
        
        let csvFileURL = resourcesURL.appendingPathComponent("localizations.csv")
        let stringsURL = resourcesURL.appendingPathComponent("ko.lproj/Translated.strings")
        #expect(!fm.fileExists(atPath: stringsURL.path))
        
        let configuration = String(
            format: Fixture.csvToStringsConfigurationFormat,
            csvFileURL.path,
            resourcesURL.path)
        
        let configurationFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try configuration.write(to: configurationFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: configurationFileURL)
        }
        
        // When
        try Config.Run.runAsRoot(arguments: [
            "--configuration-path", configurationFileURL.path,
        ])
        
        // Then
        #expect(fm.fileExists(atPath: stringsURL.path))
    }
}
