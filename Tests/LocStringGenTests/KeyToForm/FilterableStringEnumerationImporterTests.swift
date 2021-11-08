import XCTest
@testable import LocStringGen

private enum Seed {
    static let sourceCode = """
    enum StringKey: String, CaseIterable {
        /// Cancel
        case common_cancel
        
        // xcresource:key2form:exclude
        /// 100% chance!!
        case chance100
    }
    """
}

final class FilterableStringEnumerationImporterTests: XCTestCase {
    func test_example() throws {
        // Given
        let fm = FileManager.default
        
        let sourceURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".swift")
        try Seed.sourceCode.write(to: sourceURL, atomically: true, encoding: .utf8)
        defer { try? fm.removeItem(at: sourceURL) }
        
        let sut = FilterableStringEnumerationImporter(
            importer: SwiftStringEnumerationImporter(),
            commandNameOfExclusion: "xcresource:key2form:exclude")
        
        let expectedEnum = Enumeration<String>(
            identifier: "StringKey",
            cases: [
                .init(comments: [.documentLine("Cancel")],
                      identifier: "common_cancel",
                      rawValue: "common_cancel"),
            ])
        
        // When
        let actualEnum = try sut.import(at: sourceURL)
        
        // Then
        XCTAssertEqual(actualEnum, expectedEnum)
    }
}
