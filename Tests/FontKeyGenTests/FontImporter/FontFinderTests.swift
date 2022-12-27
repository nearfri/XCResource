import XCTest
import SampleData
@testable import FontKeyGen

final class FontFinderTests: XCTestCase {
    func test_find() throws {
        // Given
        let sut = FontFinder()
        
        // When
        let paths = try sut.find(at: SampleData.fontDirectoryURL())
        
        // Then
        XCTAssertEqual(paths, [
            "Avenir.ttc",
            "SFNSDisplay/SFNSDisplay-Bold.otf",
            "SFNSDisplay/SFNSDisplay-Heavy.otf",
            "SFNSDisplay/SFNSDisplay-Regular.otf",
            "ZapfDingbats.ttf",
        ])
    }
}
