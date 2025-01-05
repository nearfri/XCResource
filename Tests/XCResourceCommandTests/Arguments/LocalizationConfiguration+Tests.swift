import Testing
@testable import XCResourceCommand

@Suite struct LocalizationConfigurationTests {
    @Test func initWithArgument_withVerifyComment() throws {
        // Given
        let argument = "comment:verify-comments"
        
        // When
        let config = try #require(KeyToStringsConfiguration(argument: argument))
        
        // Then
        #expect(config.mergeStrategy == .add(.comment))
        #expect(config.verifiesComments == true)
    }
    
    @Test func initWithArgument_withoutVerifyComment() throws {
        // Given
        let argument = "comment:"
        
        // When
        let config = try #require(KeyToStringsConfiguration(argument: argument))
        
        // Then
        #expect(config.mergeStrategy == .add(.comment))
        #expect(config.verifiesComments == false)
    }
    
    @Test func initWithArgument_withoutVerifyCommentSeparator() throws {
        // Given
        let argument = "comment"
        
        // When
        let config = try #require(KeyToStringsConfiguration(argument: argument))
        
        // Then
        #expect(config.mergeStrategy == .add(.comment))
        #expect(config.verifiesComments == false)
    }
    
    @Test func initWithArgument_withUnknownOption() throws {
        // Given
        let argument = "comment:unknown-value"
        
        // When, Then
        #expect(KeyToStringsConfiguration(argument: argument) == nil)
    }
}
