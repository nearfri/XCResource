import Testing
import SampleData
@testable import FontResourceGen

@Suite struct FontFinderTests {
    @Test func find() throws {
        // Given
        let sut = FontFinder()
        
        // When
        let paths = try sut.find(at: SampleData.fontDirectoryURL())
        
        // Then
        #expect(paths == [
            "Avenir.ttc",
            "SFNSDisplay/SFNSDisplay-Bold.otf",
            "SFNSDisplay/SFNSDisplay-Heavy.otf",
            "SFNSDisplay/SFNSDisplay-Regular.otf",
            "ZapfDingbats.ttf",
        ])
    }
}
