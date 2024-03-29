import XCTest
import LocStringCore
@testable import LocSwiftCore

final class LocalizationItemTests: XCTestCase {
    func test_commentByRemovingFormatLabels() throws {
        // Given
        let sut = LocalizationItem(
            key: "key",
            value: "value",
            comment: "%{_ fileCount}ld files")
        
        // When
        let comment = sut.commentByRemovingFormatLabels
        
        // Then
        XCTAssertEqual(comment, "%ld files")
    }
    
    func test_commentContainsPluralVariables_true() throws {
        // Given
        let sut = LocalizationItem(
            key: "key",
            value: "value",
            comment: "My dog ate %#@appleCount@ today!")
        
        // When
        let containsPlural = sut.commentContainsPluralVariables
        
        // Then
        XCTAssertTrue(containsPlural)
    }
    
    func test_commentContainsPluralVariables_false() throws {
        // Given
        let sut = LocalizationItem(
            key: "key",
            value: "value",
            comment: "My dog ate no apples today!")
        
        // When
        let containsPlural = sut.commentContainsPluralVariables
        
        // Then
        XCTAssertFalse(containsPlural)
    }
}
