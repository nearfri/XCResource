import Testing
import Foundation
@testable import XCResourceCommand

@Suite struct Config_InitTests {
    @Test func runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let configurationFileURL = URL(fileURLWithPath: "./xcresource.json")
        
        defer {
            try? fm.removeItem(at: configurationFileURL)
        }
        
        // When
        try Config.Init.runAsRoot(arguments: [])
        
        // Then
        #expect(fm.fileExists(atPath: configurationFileURL.path))
        print(configurationFileURL.path)
    }
}
