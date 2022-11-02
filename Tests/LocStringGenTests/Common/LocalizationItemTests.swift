import XCTest
@testable import LocStringGen

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
    
    func test_combinedWithOther() {
        // Given
        let sut: [LocalizationItem] = [
            .init(key: "cancel", value: "cancel", comment: "cancel"),
            .init(key: "new_key", value: "new key", comment: "new key"),
            .init(key: "greeting", value: "new comment", comment: "new comment"),
        ]
        
        let other: [LocalizationItem] = [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "missing_key", value: "Missing Key", comment: "missing key"),
            .init(key: "greeting", value: "hello", comment: "old comment"),
        ]
        
        // When, Then
        XCTAssertEqual(sut.combined(with: other, verifyingComments: true), [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "new_key", value: "new key", comment: "new key"),
            .init(key: "greeting", value: "new comment", comment: "new comment"),
        ])
        
        XCTAssertEqual(sut.combined(with: other, verifyingComments: false), [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "new_key", value: "new key", comment: "new key"),
            .init(key: "greeting", value: "hello", comment: "new comment"),
        ])
    }
    
    func test_combinedIntersection() throws {
        // Given
        let sut: [LocalizationItem] = [
            .init(key: "cancel", value: "cancel", comment: "cancel"),
            .init(key: "new_key", value: "new key", comment: "new key"),
            .init(key: "greeting", value: "new comment", comment: "new comment"),
        ]
        
        let other: [LocalizationItem] = [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "missing_key", value: "Missing Key", comment: "missing key"),
            .init(key: "greeting", value: "hello", comment: "old comment"),
        ]
        
        // When, Then
        XCTAssertEqual(sut.combinedIntersection(other, verifyingComments: true), [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
        ])
        
        XCTAssertEqual(sut.combinedIntersection(other, verifyingComments: false), [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "greeting", value: "hello", comment: "new comment"),
        ])
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
