import XCTest
import SampleData
@testable import AssetKeyGen

final class ActualAssetCatalogFetcherTests: XCTestCase {
    func test_fetch() throws {
        // Given
        let sut = ActualAssetCatalogFetcher()
        let imagePath = "Settings/settingsRate.imageset"
        
        // When
        let catalogsByType: [AssetType: AssetCatalog] = try sut.fetch(at: SampleData.assetURL())
        
        // Then
        let imageCatalog = try XCTUnwrap(catalogsByType[.imageSet])
        XCTAssertEqual(imageCatalog.name, "Media.xcassets")
        XCTAssert(imageCatalog.assets.contains(where: { $0.path == imagePath }))
    }
}
