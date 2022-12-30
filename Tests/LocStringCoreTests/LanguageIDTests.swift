import XCTest
@testable import LocStringCore

final class LanguageIDTests: XCTestCase {
    func test_sortedUsingPreferredLanguages() {
        // Given
        let languages: [LanguageID] = ["id", "es", "ar", "en", "ko"]
        
        // When
        let sortedLanguages = languages.sorted(usingPreferredLanguages: ["ko", "en"])
        
        // Then
        XCTAssertEqual(sortedLanguages, ["ko", "en", "ar", "es", "id"])
    }
}
