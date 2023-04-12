import XCTest
@testable import LocStringCore

private class FakeLocalizationItemFilter: LocalizationItemFilter {
    func isIncluded(_ item: LocalizationItem) -> Bool {
        return item.comment?.contains("%#@") == false
    }
}

final class LocalizationItemImporterFilterDecoratorTests: XCTestCase {
    func test_import_usesFilter() throws {
        // Given
        class StubSourceCodeImporter: LocalizationItemImporter {
            static let singularItem = LocalizationItem(
                key: "greeting",
                value: "",
                comment: "Hello World")
            
            static let pluralItem = LocalizationItem(
                key: "dogEatingApples",
                value: "",
                comment: "My dog ate %#@appleCount@ today!")
            
            func `import`(at url: URL) throws -> [LocalizationItem] {
                return [Self.singularItem, Self.pluralItem]
            }
        }
        
        let sut = LocalizationItemImporterFilterDecorator(
            decoratee: StubSourceCodeImporter(),
            filter: FakeLocalizationItemFilter())
        
        // When
        let importedItems = try sut.import(at: URL(fileURLWithPath: ""))
        
        // Then
        XCTAssertEqual(importedItems, [StubSourceCodeImporter.singularItem])
    }
}
