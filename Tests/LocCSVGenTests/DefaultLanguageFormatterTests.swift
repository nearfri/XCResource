import XCTest
import LocStringCore
@testable import LocCSVGen

private enum Fixture {
    static let language: LanguageID = "ko"
}

final class DefaultLanguageFormatterTests: XCTestCase {
    private let sut: DefaultLanguageFormatter = .init()
    
    func test_stringFromLanguage_shortStyle() {
        // Given
        sut.style = .short
        
        // When
        let languageAsString = sut.string(from: Fixture.language)
        
        // Then
        XCTAssertEqual(languageAsString, "ko")
    }
    
    func test_stringFromLanguage_longStyle() {
        // Given
        sut.style = .long(Locale(identifier: "en"))
        
        // When
        let languageAsString = sut.string(from: Fixture.language)
        
        // Then
        XCTAssertEqual(languageAsString, "Korean (ko)")
    }
    
    func test_languageFromString_shortStyle() {
        // Given
        sut.style = .short
        
        // When
        let language = sut.language(from: "ko")
        
        // Then
        XCTAssertEqual(language, Fixture.language)
    }
    
    func test_languageFromString_longStyle() {
        // Given
        sut.style = .long(Locale(identifier: "en"))
        
        // When
        let language = sut.language(from: "Korean (ko)")
        
        // Then
        XCTAssertEqual(language, Fixture.language)
    }
}
