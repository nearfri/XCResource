import XCTest
@testable import XCResourceCommand

final class LanguageAndConfigurationTests: XCTestCase {
    func test_initWithArgument() throws {
        // Given
        let argument = "ko:comment:verify-comments"
        
        // When
        let langAndConfig = try XCTUnwrap(LanguageAndStringsConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(langAndConfig.language, "ko")
        XCTAssertEqual(langAndConfig.configuration.mergeStrategy, .add(.comment))
        XCTAssertEqual(langAndConfig.configuration.verifiesComments, true)
    }
}
