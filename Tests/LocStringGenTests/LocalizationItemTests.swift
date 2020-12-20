import XCTest
@testable import LocStringGen

final class LocalizationItemTests: XCTestCase {
    func test_applyingValueStrategy() {
        let sut = LocalizationItem(comment: "Comment String",
                                   key: "Key String",
                                   value: "")
        
        XCTAssertEqual(sut.applying(.comment).value, "Comment String")
        XCTAssertEqual(sut.applying(.key).value, "Key String")
        XCTAssertEqual(sut.applying(.custom("Custom String")).value, "Custom String")
    }
    
    func test_combiningOther() {
        // Given
        let sut: [LocalizationItem] = [
            .init(comment: nil, key: "cancel", value: ""),
            .init(comment: nil, key: "confirm", value: ""),
            .init(comment: nil, key: "new_key", value: ""),
        ]
        
        let other: [LocalizationItem] = [
            .init(comment: nil, key: "cancel", value: "취소"),
            .init(comment: nil, key: "confirm", value: "확인"),
            .init(comment: nil, key: "missing_key", value: "없어진 키")
        ]
        
        let expectedCombinedItems: [LocalizationItem] = [
            .init(comment: nil, key: "cancel", value: "취소"),
            .init(comment: nil, key: "confirm", value: "확인"),
            .init(comment: nil, key: "new_key", value: ""),
        ]
        
        // When
        let actualCombinedItems = sut.combining(other)
        
        // Then
        XCTAssertEqual(actualCombinedItems, expectedCombinedItems)
    }
    
    func test_sortedBy_occurrence() {
        // Given
        let sut: [LocalizationItem] = [
            .init(comment: nil, key: "confirm", value: ""),
            .init(comment: nil, key: "cancel", value: ""),
        ]
        
        let expectedSortedItems: [LocalizationItem] = [
            .init(comment: nil, key: "confirm", value: ""),
            .init(comment: nil, key: "cancel", value: ""),
        ]
        
        // When
        let actualSortedItems = sut.sorted(by: .occurrence)
        
        // Then
        XCTAssertEqual(actualSortedItems, expectedSortedItems)
    }
    
    func test_sortedBy_key() {
        // Given
        let sut: [LocalizationItem] = [
            .init(comment: nil, key: "confirm", value: ""),
            .init(comment: nil, key: "cancel", value: ""),
        ]
        
        let expectedSortedItems: [LocalizationItem] = [
            .init(comment: nil, key: "cancel", value: ""),
            .init(comment: nil, key: "confirm", value: ""),
        ]
        
        // When
        let actualSortedItems = sut.sorted(by: .key)
        
        // Then
        XCTAssertEqual(actualSortedItems, expectedSortedItems)
    }
}
