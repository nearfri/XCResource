import XCTest
import LocStringCore
@testable import LocStringsGen

final class LocalizationItemTests: XCTestCase {
    func test_applyingAddingMethod() {
        let sut = LocalizationItem(key: "Key String",
                                   value: "",
                                   comment: "Comment String")
        
        XCTAssertEqual(sut.applying(.comment).value, "Comment String")
        XCTAssertEqual(sut.applying(.key).value, "Key String")
        XCTAssertEqual(sut.applying(.label("Custom String")).value, "Custom String")
    }
    
    func test_applyingAddingMethod_formattedComment() {
        let sut = LocalizationItem(key: "Key String",
                                   value: "",
                                   comment: "Comment %{count}ld %ld{bracket} String")
        
        XCTAssertEqual(sut.applying(.comment).value, "Comment %ld %ld{bracket} String")
    }
    
    func test_sortedBy_occurrence() {
        // Given
        let sut: [LocalizationItem] = [
            .init(key: "confirm", value: "", comment: nil),
            .init(key: "cancel", value: "", comment: nil),
        ]
        
        let expectedSortedItems: [LocalizationItem] = [
            .init(key: "confirm", value: "", comment: nil),
            .init(key: "cancel", value: "", comment: nil),
        ]
        
        // When
        let actualSortedItems = sut.sorted(by: .occurrence)
        
        // Then
        XCTAssertEqual(actualSortedItems, expectedSortedItems)
    }
    
    func test_sortedBy_key() {
        // Given
        let sut: [LocalizationItem] = [
            .init(key: "confirm", value: "", comment: nil),
            .init(key: "cancel", value: "", comment: nil),
        ]
        
        let expectedSortedItems: [LocalizationItem] = [
            .init(key: "cancel", value: "", comment: nil),
            .init(key: "confirm", value: "", comment: nil),
        ]
        
        // When
        let actualSortedItems = sut.sorted(by: .key)
        
        // Then
        XCTAssertEqual(actualSortedItems, expectedSortedItems)
    }
}
