import XCTest
import LocCSVGen
@testable import XCResourceCommand

final class LanguageFormatterStyleTests: XCTestCase {
    func test_initWithArgument_short() throws {
        XCTAssertEqual(LanguageFormatterStyle(argument: "short"), .short)
    }
    
    func test_initWithArgument_long() throws {
        XCTAssertEqual(LanguageFormatterStyle(argument: "long"), .long(Locale.current))
    }
    
    func test_initWithArgument_long_locale() throws {
        XCTAssertEqual(LanguageFormatterStyle(argument: "long-ko"), .long(Locale(identifier: "ko")))
    }
}
