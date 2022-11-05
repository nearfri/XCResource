import XCTest
import SampleData
@testable import LocStringGen

final class ASCIIPlistImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let sut = ASCIIPlistImporter()
        let stringsURL = SampleData.localizationDirectoryURL()
            .appendingPathComponent("en.lproj/Localizable.strings")
        
        let expectedItems: [LocalizationItem] = [
            LocalizationItem(key: "common_cancel", value: "Cancel", comment: "취소"),
            LocalizationItem(key: "common_confirm", value: "Confirm", comment: "확인")
        ]
        
        // When
        let actualItems = try sut.import(at: stringsURL)
        
        // Then
        XCTAssertEqual(actualItems, expectedItems)
    }
}

