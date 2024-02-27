import XCTest
@testable import LocSwiftCore

private enum Fixture {
    static let sourceCode = """
    enum StringKey: String, CaseIterable {
        /// Cancel
        case common_cancel
    }
    
    enum IgnoredEnum: String, CaseIterable {
        /// Cancel
        case common_cancel
    }
    """
}

final class SwiftStringEnumerationImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let fm = FileManager.default
        
        let sourceURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".swift")
        try Fixture.sourceCode.write(to: sourceURL, atomically: true, encoding: .utf8)
        defer { try? fm.removeItem(at: sourceURL) }
        
        let sut = SwiftStringEnumerationImporter()
        
        let expectedEnum = Enumeration<String>(
            name: "StringKey",
            cases: [
                .init(comments: [.documentLine("Cancel")],
                      name: "common_cancel",
                      rawValue: "common_cancel"),
            ])
        
        // When
        let actualEnum = try sut.import(at: sourceURL)
        
        // Then
        XCTAssertEqual(actualEnum, expectedEnum)
    }
}
