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
            "SFNSDisplay/SFNSDisplay-Black.otf",
            "SFNSDisplay/SFNSDisplay-Bold.otf",
            "SFNSDisplay/SFNSDisplay-Heavy.otf",
            "SFNSDisplay/SFNSDisplay-Regular.otf",
            "SFNSText/SFNSText-Bold.otf",
            "SFNSText/SFNSText-Heavy.otf",
            "SFNSText/SFNSText-Regular.otf",
            "ZapfDingbats.ttf",
        ])
    }
}
