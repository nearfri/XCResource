import Testing
@testable import XCResourceCommand

@Suite struct LanguageAndConfigurationTests {
    @Test func initWithArgument() throws {
        // Given
        let argument = "ko:comment:verify-comments"
        
        // When
        let langAndConfig = try #require(LanguageAndStringsConfiguration(argument: argument))
        
        // Then
        #expect(langAndConfig.language == "ko")
        #expect(langAndConfig.configuration.mergeStrategy == .add(.comment))
        #expect(langAndConfig.configuration.verifiesComments == true)
    }
}
