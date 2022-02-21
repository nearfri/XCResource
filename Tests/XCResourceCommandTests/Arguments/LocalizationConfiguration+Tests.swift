import XCTest
@testable import XCResourceCommand

final class LocalizationConfigurationTests: XCTestCase {
    func test_initWithArgument_withVerifyComment() throws {
        // Given
        let argument = "comment:verify-comment"
        
        // When
        let config = try XCTUnwrap(LocalizationConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(config.mergeStrategy, .add(.comment))
        XCTAssertEqual(config.verifiesComment, true)
    }
    
    func test_initWithArgument_withoutVerifyComment() throws {
        // Given
        let argument = "comment:"
        
        // When
        let config = try XCTUnwrap(LocalizationConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(config.mergeStrategy, .add(.comment))
        XCTAssertEqual(config.verifiesComment, false)
    }
    
    func test_initWithArgument_withoutVerifyCommentSeparator() throws {
        // Given
        let argument = "comment"
        
        // When
        let config = try XCTUnwrap(LocalizationConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(config.mergeStrategy, .add(.comment))
        XCTAssertEqual(config.verifiesComment, false)
    }
    
    func test_initWithArgument_withUnknownOption() throws {
        // Given
        let argument = "comment:unknown-value"
        
        // When, Then
        XCTAssertNil(LocalizationConfiguration(argument: argument))
    }
}