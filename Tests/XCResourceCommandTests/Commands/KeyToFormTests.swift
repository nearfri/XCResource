import XCTest
@testable import XCResourceCommand
import SampleData

final class KeyToFormTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let formFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: formFileURL)
        }
        
        // When
        try KeyToForm.runAsRoot(arguments: [
            "--key-file-path", SampleData.sourceCodeURL("StringKey.swift").path,
            "--form-file-path", formFileURL.path,
            "--form-type-name", "StringForm",
        ])
        
        // Then
        XCTAssertEqual(
            try String(contentsOf: formFileURL)
                .replacingOccurrences(of: "xctest", with: "xcresource"),
            try String(contentsOf: SampleData.sourceCodeURL("StringForm.swift"))
        )
    }
}
