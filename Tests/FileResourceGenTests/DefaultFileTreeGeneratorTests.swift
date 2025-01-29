import Testing
import SampleData
@testable import FileResourceGen

@Suite struct DefaultFileTreeGeneratorTests {
    @Test func load() throws {
        // Given
        let sut = DefaultFileTreeGenerator()
        
        // When
        let fileTree = try sut.load(at: SampleData.fontDirectoryURL())
        
        // Then
        let urls = fileTree.makePreOrderSequence().map(\.relativePath)
        #expect(urls == [
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
