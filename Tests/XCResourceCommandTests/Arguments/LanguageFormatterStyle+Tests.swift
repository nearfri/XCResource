import Testing
import Foundation
import LocCSVGen
@testable import XCResourceCommand

@Suite struct LanguageFormatterStyleTests {
    @Test func initWithArgument_short() throws {
        #expect(LanguageFormatterStyle(argument: "short") == .short)
    }
    
    @Test func initWithArgument_long() throws {
        #expect(LanguageFormatterStyle(argument: "long") == .long(Locale.current))
    }
    
    @Test func initWithArgument_long_locale() throws {
        #expect(LanguageFormatterStyle(argument: "long-ko") == .long(Locale(identifier: "ko")))
    }
}
