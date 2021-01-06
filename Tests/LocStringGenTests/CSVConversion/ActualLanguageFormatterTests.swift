import XCTest
@testable import LocStringGen

private enum Seed {
    static let language: LanguageID = "ko"
}

final class ActualLanguageFormatterTests: XCTestCase {
    private let sut: ActualLanguageFormatter = .init()
    
    func test_stringFromLanguage_shortStyle() {
        // Given
        sut.style = .short
        
        // When
        let languageAsString = sut.string(from: Seed.language)
        
        // Then
        XCTAssertEqual(languageAsString, "ko")
    }
    
    func test_stringFromLanguage_longStyle() {
        // Given
        sut.style = .long(Locale(identifier: "en"))
        
        // When
        let languageAsString = sut.string(from: Seed.language)
        
        // Then
        XCTAssertEqual(languageAsString, "Korean (ko)")
    }
    
    func test_languageFromString_shortStyle() {
        // Given
        sut.style = .short
        
        // When
        let language = sut.language(from: "ko")
        
        // Then
        XCTAssertEqual(language, Seed.language)
    }
    
    func test_languageFromString_longStyle() {
        // Given
        sut.style = .long(Locale(identifier: "en"))
        
        // When
        let language = sut.language(from: "Korean (ko)")
        
        // Then
        XCTAssertEqual(language, Seed.language)
    }
}
