import XCTest
@testable import XCResourceCommand

final class LanguageAndMergeStrategyTests: XCTestCase {
    func test_initWithArgument() throws {
        // Given
        let argument = "ko:comment"
        
        // When
        let strategyArgument = try XCTUnwrap(LanguageAndMergeStrategy(argument: argument))
        
        // Then
        XCTAssertEqual(strategyArgument.language, "ko")
        XCTAssertEqual(strategyArgument.strategy, .add(.comment))
    }
}
