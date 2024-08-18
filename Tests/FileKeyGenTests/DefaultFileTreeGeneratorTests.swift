import XCTest
import SampleData
@testable import FileKeyGen

final class DefaultFileTreeGeneratorTests: XCTestCase {
    func test_load() throws {
        // Given
        let sut = DefaultFileTreeGenerator()
        
        // When
        let fileTree = try sut.load(at: SampleData.fontDirectoryURL())
        
        // Then
        let urls = fileTree.makePreOrderSequence().map(\.relativePath)
        XCTAssertEqual(urls, [
            "",
            "SFNSDisplay",
            "SFNSDisplay/SFNSDisplay-Bold.otf",
            "SFNSDisplay/SFNSDisplay-Heavy.otf",
            "SFNSDisplay/SFNSDisplay-Regular.otf",
            "Avenir.ttc",
            "FontList.txt",
            "ZapfDingbats.ttf",
        ])
    }
}
