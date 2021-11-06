import XCTest
@testable import LocStringGen

private enum Seed {
    static let sourceCode = """
    enum StringKey: String, CaseIterable {
        /// 취소
        case common_cancel
    }
    
    enum IgnoredEnum: String, CaseIterable {
        /// 취소
        case common_cancel
    }
    """
}

final class DefaultStringEnumerationImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let fm = FileManager.default
        
        let sourceURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".swift")
        try Seed.sourceCode.write(to: sourceURL, atomically: true, encoding: .utf8)
        defer { try? fm.removeItem(at: sourceURL) }
        
        let sut = DefaultStringEnumerationImporter()
        
        let expectedEnum = Enumeration<String>(
            identifier: "StringKey",
            cases: [
                .init(comments: [.documentLine("취소")],
                      identifier: "common_cancel",
                      rawValue: "common_cancel"),
            ])
        
        // When
        let actualEnum = try sut.import(at: sourceURL)
        
        // Then
        XCTAssertEqual(actualEnum, expectedEnum)
    }
}
