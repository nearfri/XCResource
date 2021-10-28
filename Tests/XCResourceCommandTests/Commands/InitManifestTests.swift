import XCTest
@testable import XCResourceCommand

final class InitManifestTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let manifestFileURL = URL(fileURLWithPath: "./xcresource.json")
        
        defer {
            try? fm.removeItem(at: manifestFileURL)
        }
        
        // When
        try InitManifest.runAsRoot(arguments: [])
        
        // Then
        XCTAssert(fm.fileExists(atPath: manifestFileURL.path))
        print(manifestFileURL.path)
    }
}
