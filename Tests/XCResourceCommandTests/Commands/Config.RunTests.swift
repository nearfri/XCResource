import Testing
import Foundation
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let configurationFormat = """
    {
        "commands": [
            {
                "commandName": "xcstrings2swift",
                "catalogPath": "%@",
                "bundle": ".atURL(Bundle.module.bundleURL)",
                "swiftFilePath": "%@"
            },
            {
                "commandName": "fonts2swift",
                "resourcesPath": "%@",
                "swiftFilePath": "%@",
                "resourceTypeName": "FontResource",
                "bundle": "Bundle.module"
            }
        ]
    }
    """
}

@Suite struct Config_RunTests {
    @Test func runAsRoot_configuration() throws {
        // Given
        let fm = FileManager.default
        
        func makeUniqueURL() -> URL {
            return fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        }
        
        let resourcesURL = makeUniqueURL()
        try fm.copyItem(at: SampleData.resourcesURL(), to: resourcesURL)
        
        let stringCatalogFileURL = resourcesURL.appendingPathComponent("Localizable.xcstrings")
        
        let stringResourceFileURL = makeUniqueURL()
        
        let fontResourceFileURL = makeUniqueURL()
        
        let configuration = String(
            format: Fixture.configurationFormat,
            stringCatalogFileURL.path,
            stringResourceFileURL.path,
            resourcesURL.appendingPathComponent("Fonts").path,
            fontResourceFileURL.path)
        
        let configurationFileURL = makeUniqueURL()
        try configuration.write(to: configurationFileURL, atomically: true, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: stringResourceFileURL)
            try? fm.removeItem(at: fontResourceFileURL)
            try? fm.removeItem(at: configurationFileURL)
        }
        
        // When
        try Config.Run.runAsRoot(arguments: [
            "--configuration-path", configurationFileURL.path,
        ])
        
        // Then
        #expect(fm.fileExists(atPath: stringResourceFileURL.path))
        #expect(fm.fileExists(atPath: fontResourceFileURL.path))
    }
}
