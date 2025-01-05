import Testing
import Foundation
@testable import XCResourceCommand

@Suite struct InitManifestTests {
    @Test func runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let manifestFileURL = URL(fileURLWithPath: "./xcresource.json")
        
        defer {
            try? fm.removeItem(at: manifestFileURL)
        }
        
        // When
        try InitManifest.runAsRoot(arguments: [])
        
        // Then
        #expect(fm.fileExists(atPath: manifestFileURL.path))
        print(manifestFileURL.path)
    }
}
