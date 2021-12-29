import XCTest
@testable import XCResourceCommand

final class LanguageAndConfigurationTests: XCTestCase {
    func test_initWithArgument() throws {
        // Given
        let argument = "ko:comment:verify-comment"
        
        // When
        let langAndConfig = try XCTUnwrap(LanguageAndConfiguration(argument: argument))
        
        // Then
        XCTAssertEqual(langAndConfig.language, "ko")
        XCTAssertEqual(langAndConfig.configuration.mergeStrategy, .add(.comment))
        XCTAssertEqual(langAndConfig.configuration.verifiesComment, true)
    }
}
