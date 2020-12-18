import XCTest
import SampleData
@testable import LocStringGen

final class ActualLanguageDetectorTests: XCTestCase {
    func test_detect() throws {
        // Given
        let sut = ActualLanguageDetector()
        let resourcesURL = SampleData.localizationDirectoryURL()
        
        // When
        let languageIDs = try sut.detect(at: resourcesURL)
        
        // Then
        XCTAssert(languageIDs.contains("ko"))
        XCTAssert(languageIDs.contains("en"))
    }
}
