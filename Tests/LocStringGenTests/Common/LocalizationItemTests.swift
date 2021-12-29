import XCTest
@testable import LocStringGen

final class LocalizationItemTests: XCTestCase {
    func test_applyingAddingMethod() {
        let sut = LocalizationItem(comment: "Comment String",
                                   key: "Key String",
                                   value: "")
        
        XCTAssertEqual(sut.applying(.comment).value, "Comment String")
        XCTAssertEqual(sut.applying(.key).value, "Key String")
        XCTAssertEqual(sut.applying(.label("Custom String")).value, "Custom String")
    }
    
    func test_applyingAddingMethod_formattedComment() {
        let sut = LocalizationItem(comment: "Comment %ld{count} %ld{{bracket} String",
                                   key: "Key String",
                                   value: "")
        
        XCTAssertEqual(sut.applying(.comment).value, "Comment %ld %ld{bracket} String")
    }
    
    func test_combinedWithOther() {
        // Given
        let sut: [LocalizationItem] = [
            .init(comment: "cancel", key: "cancel", value: "cancel"),
            .init(comment: "new key", key: "new_key", value: "new key"),
            .init(comment: "new comment", key: "greeting", value: "new comment"),
        ]
        
        let other: [LocalizationItem] = [
            .init(comment: "cancel", key: "cancel", value: "Cancel"),
            .init(comment: "missing key", key: "missing_key", value: "Missing Key"),
            .init(comment: "old comment", key: "greeting", value: "hello"),
        ]
        
        // When, Then
        XCTAssertEqual(sut.combined(with: other, verifyingComments: true), [
            .init(comment: "cancel", key: "cancel", value: "Cancel"),
            .init(comment: "new key", key: "new_key", value: "new key"),
            .init(comment: "new comment", key: "greeting", value: "new comment"),
        ])
        
        XCTAssertEqual(sut.combined(with: other, verifyingComments: false), [
            .init(comment: "cancel", key: "cancel", value: "Cancel"),
            .init(comment: "new key", key: "new_key", value: "new key"),
            .init(comment: "new comment", key: "greeting", value: "hello"),
        ])
    }
    
    func test_combinedIntersection() throws {
        // Given
        let sut: [LocalizationItem] = [
            .init(comment: "cancel", key: "cancel", value: "cancel"),
            .init(comment: "new key", key: "new_key", value: "new key"),
            .init(comment: "new comment", key: "greeting", value: "new comment"),
        ]
        
        let other: [LocalizationItem] = [
            .init(comment: "cancel", key: "cancel", value: "Cancel"),
            .init(comment: "missing key", key: "missing_key", value: "Missing Key"),
            .init(comment: "old comment", key: "greeting", value: "hello"),
        ]
        
        // When, Then
        XCTAssertEqual(sut.combinedIntersection(other, verifyingComments: true), [
            .init(comment: "cancel", key: "cancel", value: "Cancel"),
        ])
        
        XCTAssertEqual(sut.combinedIntersection(other, verifyingComments: false), [
            .init(comment: "cancel", key: "cancel", value: "Cancel"),
            .init(comment: "new comment", key: "greeting", value: "hello"),
        ])
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
