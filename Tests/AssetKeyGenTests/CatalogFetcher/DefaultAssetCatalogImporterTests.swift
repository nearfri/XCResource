import XCTest
import SampleData
@testable import AssetKeyGen

final class DefaultAssetCatalogImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let sut = DefaultAssetCatalogImporter()
        let imagePath = "Settings/settingsRate.imageset"
        
        // When
        let catalog: AssetCatalog = try sut.import(at: SampleData.assetURL())
        
        // Then
        XCTAssertEqual(catalog.name, "Media.xcassets")
        XCTAssert(catalog.assets.contains(where: { $0.path == imagePath }))
    }
}
