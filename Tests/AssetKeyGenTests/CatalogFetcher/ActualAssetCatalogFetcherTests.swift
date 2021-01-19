import XCTest
import SampleData
@testable import AssetKeyGen

final class ActualAssetCatalogFetcherTests: XCTestCase {
    func test_fetch() throws {
        // Given
        let sut = ActualAssetCatalogFetcher()
        let imagePath = "Settings/settingsRate.imageset"
        
        // When
        let catalog: AssetCatalog = try sut.fetch(at: SampleData.assetURL())
        
        // Then
        XCTAssertEqual(catalog.name, "Media.xcassets")
        XCTAssert(catalog.assets.contains(where: { $0.path == imagePath }))
    }
}
