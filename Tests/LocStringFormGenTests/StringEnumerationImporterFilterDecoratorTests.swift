import XCTest
import LocSwiftCore
@testable import LocStringFormGen

final class StringEnumerationImporterFilterDecoratorTests: XCTestCase {
    func test_import_removeCommentedWithExclude() throws {
        // Given
        class StubStringEnumerationImporter: StringEnumerationImporter {
            static let enumeration = Enumeration<String>(
                identifier: "StringKey",
                cases: [
                    .init(
                        comments: [
                            .documentLine("Cancel")
                        ],
                        identifier: "common_cancel",
                        rawValue: "common_cancel"),
                    .init(
                        comments: [
                            .line("xcresource:key2form:exclude"),
                            .documentLine("100% chance!!")
                        ],
                        identifier: "chance100",
                        rawValue: "chance100"),
                ])
            
            func `import`(at url: URL) throws -> Enumeration<String> {
                return Self.enumeration
            }
        }
        
        let sut = StringEnumerationImporterFilterDecorator(
            decoratee: StubStringEnumerationImporter(),
            commandNameForExclusion: "xcresource:key2form:exclude")
        
        let expectedEnum = Enumeration<String>(
            identifier: "StringKey",
            cases: [
                .init(comments: [.documentLine("Cancel")],
                      identifier: "common_cancel",
                      rawValue: "common_cancel"),
            ])
        
        // When
        let actualEnum = try sut.import(at: URL(fileURLWithPath: ""))
        
        // Then
        XCTAssertEqual(actualEnum, expectedEnum)
    }
}
