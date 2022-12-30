import XCTest
import SampleData
@testable import LocStringCore

final class DefaultLanguageDetectorTests: XCTestCase {
    func test_detect() throws {
        // Given
        let sut = DefaultLanguageDetector()
        let resourcesURL = SampleData.localizationDirectoryURL()
        
        // When
        let languageIDs = try sut.detect(at: resourcesURL)
        
        // Then
        XCTAssert(languageIDs.contains("ko"))
        XCTAssert(languageIDs.contains("en"))
    }
}
