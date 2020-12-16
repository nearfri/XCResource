import XCTest
import SampleData
@testable import LocStringGen

final class LocalizationTargetFetcherTests: XCTestCase {
    func test_fetch() throws {
        // Given
        let sut = LocalizationTargetImporter()
        let stringsURL = SampleData.resourcesURL()
            .appendingPathComponent("en.lproj/Localizable.strings")
        
        let expectedItems: [LocalizationItem] = [
            LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
            LocalizationItem(comment: "확인", key: "confirm", value: "Confirm")
        ]
        
        // When
        let actualItems = try sut.import(at: stringsURL)
        
        // Then
        XCTAssertEqual(actualItems, expectedItems)
    }
}

