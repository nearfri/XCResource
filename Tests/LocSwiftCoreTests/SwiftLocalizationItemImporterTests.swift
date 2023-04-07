import XCTest
import LocStringCore
@testable import LocSwiftCore

private class StubStringEnumerationImporter: StringEnumerationImporter {
    func `import`(at url: URL) throws -> Enumeration<String> {
        return .init(identifier: "StringKey", cases: [
            .init(
                comments: [
                    .line("line - cancel 1."),
                    .line("line - cancel 2."),
                    .documentLine("document line - cancel 1."),
                    .documentLine("document line - cancel 2."),
                ],
                identifier: "common_cancel",
                rawValue: "common_cancel"),
            .init(
                comments: [
                    .block("block - confirm 1."),
                    .block("block - confirm 2."),
                    .documentBlock("document block - confirm 1."),
                    .documentBlock("document block - confirm 2."),
                ],
                identifier: "common_confirm",
                rawValue: "common_confirm"),
        ])
    }
}

final class SwiftLocalizationItemImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let sut = SwiftLocalizationItemImporter(
            enumerationImporter: StubStringEnumerationImporter())
        
        let expectedItems: [LocalizationItem] = [
            .init(key: "common_cancel",
                  value: "",
                  comment: "document line - cancel 1. document line - cancel 2."),
            .init(key: "common_confirm",
                  value: "",
                  comment: "document block - confirm 1. document block - confirm 2."),
        ]
        
        // When
        let actualItems: [LocalizationItem] = try sut.import(at: URL(fileURLWithPath: ""))
        
        // Then
        XCTAssertEqual(actualItems, expectedItems)
    }
}