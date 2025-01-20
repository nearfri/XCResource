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
    
    func test_hasCommandName_commentsHaveCommand_returnsTrue() throws {
        // Given
        let sut = LocalizationItem(
            key: "key",
            value: "value",
            developerComments: ["xcresource:target:stringsdict"])
        
        // When
        let hasCommandName = sut.hasCommentDirective("xcresource:target:stringsdict")
        
        // Then
        XCTAssertTrue(hasCommandName)
    }
    
    func test_hasCommandName_commentsDoNotHaveCommand_returnsFalse() throws {
        // Given
        let sut = LocalizationItem(
            key: "key",
            value: "value",
            developerComments: ["xcresource:other:command"])
        
        // When
        let hasCommandName = sut.hasCommentDirective("xcresource:target:stringsdict")
        
        // Then
        XCTAssertFalse(hasCommandName)
    }
}
