import XCTest
@testable import LocSwiftCore

final class EnumerationCaseTests: XCTestCase {
    func test_hasCommandName_commentsContainCommandName_returnsTrue() throws {
        // Given
        let sut = Enumeration.Case(
            comments: [.line("xcresource:customcommand"), .documentLine("hello world")],
            name: "greeting",
            rawValue: "greeting")
        
        // When
        let hasCommand = sut.hasCommandName("xcresource:customcommand")
        
        // Then
        XCTAssert(hasCommand)
    }
    
    func test_hasCommandName_commentsDonNotContainCommandName_returnsFalse() throws {
        // Given
        let sut = Enumeration.Case(
            comments: [.line("xcresource:customcommand"), .documentLine("hello world")],
            name: "greeting",
            rawValue: "greeting")
        
        // When
        let hasCommand = sut.hasCommandName("xcresource:mycommand")
        
        // Then
        XCTAssertFalse(hasCommand)
    }
}
