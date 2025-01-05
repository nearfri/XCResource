import Testing
import SampleData
@testable import AssetKeyGen

@Suite struct DefaultAssetCatalogImporterTests {
    @Test func importCatalog() throws {
        // Given
        let sut = DefaultAssetCatalogImporter()
        let imagePath = "Settings/settingsRate.imageset"
        
        // When
        let catalog: AssetCatalog = try sut.import(at: SampleData.assetURL())
        
        // Then
        #expect(catalog.name == "Media.xcassets")
        #expect(catalog.assets.contains(where: { $0.path == imagePath }))
    }
}
