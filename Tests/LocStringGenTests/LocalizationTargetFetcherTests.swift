import XCTest
import SampleData
@testable import LocStringGen

final class LocalizationTargetFetcherTests: XCTestCase {
    func test_fetch() throws {
        // Given
        let sut = LocalizationTargetImporter()
        let stringsURL = SampleData.localizationDirectoryURL()
            .appendingPathComponent("en.lproj/Localizable.strings")
        
        let expectedItems: [LocalizationItem] = [
            LocalizationItem(comment: nil, key: "common_cancel", value: "Cancel"),
            LocalizationItem(comment: nil, key: "common_confirm", value: "Confirm")
        ]
        
        // When
        let actualItems = try sut.import(at: stringsURL)
        
        // Then
        XCTAssertEqual(actualItems.count, expectedItems.count)
        XCTAssertEqual(actualItems.reduce(into: [:], { $0[$1.key] = $1 }),
                       expectedItems.reduce(into: [:], { $0[$1.key] = $1 }))
    }
}

