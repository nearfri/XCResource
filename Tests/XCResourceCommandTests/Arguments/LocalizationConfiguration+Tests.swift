import XCTest
@testable import XCResourceCommand

final class LocalizationConfigurationTests: XCTestCase {
    func test_initWithArgument_withVerifyComment() throws {
        // Given
        let argument = "comment:verify-comments"
        
        // When
        let config = try XCTUnwrap(KeyToStringsConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(config.mergeStrategy, .add(.comment))
        XCTAssertEqual(config.verifiesComments, true)
    }
    
    func test_initWithArgument_withoutVerifyComment() throws {
        // Given
        let argument = "comment:"
        
        // When
        let config = try XCTUnwrap(KeyToStringsConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(config.mergeStrategy, .add(.comment))
        XCTAssertEqual(config.verifiesComments, false)
    }
    
    func test_initWithArgument_withoutVerifyCommentSeparator() throws {
        // Given
        let argument = "comment"
        
        // When
        let config = try XCTUnwrap(KeyToStringsConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(config.mergeStrategy, .add(.comment))
        XCTAssertEqual(config.verifiesComments, false)
    }
    
    func test_initWithArgument_withUnknownOption() throws {
        // Given
        let argument = "comment:unknown-value"
        
        // When, Then
        XCTAssertNil(KeyToStringsConfiguration(argument: argument))
    }
}
