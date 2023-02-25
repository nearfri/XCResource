import XCTest
@testable import LocStringCore

final class LocalizationItemTests: XCTestCase {
    func test_fixingIDForSwift_validID_returnsEqual() throws {
        // Given
        let sut = LocalizationItem(
            id: "valid_key",
            key: "valid_key",
            value: "hello",
            comment: "greeting")
        
        // When
        let fixed = sut.fixingIDForSwift()
        
        // Then
        XCTAssertEqual(fixed, sut)
    }
    
    func test_fixingIDForSwift_invalidID_returnsFixed() throws {
        // Given
        let sut = LocalizationItem(
            id: "punctuation/key",
            key: "punctuation/key",
            value: "hello",
            comment: "greeting")
        
        let expected = LocalizationItem(
            id: "punctuation_key",
            key: "punctuation/key",
            value: "hello",
            comment: "greeting")
        
        // When
        let fixed = sut.fixingIDForSwift()
        
        // Then
        XCTAssertEqual(fixed, expected)
    }
    
    func test_fixingIDForSwift_idStartsWithNumber_returnsFixed() throws {
        // Given
        let sut = LocalizationItem(
            id: "1number_key",
            key: "1number_key",
            value: "hello",
            comment: "greeting")
        
        let expected = LocalizationItem(
            id: "_1number_key",
            key: "1number_key",
            value: "hello",
            comment: "greeting")
        
        // When
        let fixed = sut.fixingIDForSwift()
        
        // Then
        XCTAssertEqual(fixed, expected)
    }
}
