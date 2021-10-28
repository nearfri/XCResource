import XCTest
@testable import XCResourceCommand

class ValueStrategyArgumentTests: XCTestCase {
    func test_initWithArgument() throws {
        // Given
        let argument = "ko:comment"
        
        // When
        let strategyArgument = try XCTUnwrap(ValueStrategyArgument(argument: argument))
        
        // Then
        XCTAssertEqual(strategyArgument.language, "ko")
        XCTAssertEqual(strategyArgument.strategy, .comment)
    }
}
