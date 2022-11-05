import XCTest
@testable import LocStringGen

final class SingularLocalizationItemImporterDecoratorTests: XCTestCase {
    func test_import_excludePlurals() throws {
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
        
        let sut = SingularLocalizationItemImporterDecorator(
            importer: StubSourceCodeImporter())
        
        // When
        let importedItems = try sut.import(at: URL(fileURLWithPath: ""))
        
        // Then
        XCTAssertEqual(importedItems, [StubSourceCodeImporter.singularItem])
    }
}
