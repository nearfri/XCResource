import XCTest
@testable import AssetKeyGen

final class AssetFolderTests: XCTestCase {
    func test_addChild() throws {
        // Given
        let assetSet = AssetSet(type: .image, name: "check")
        let assetFolder = AssetFolder(name: "Bar", providesNamespace: false)

        // When
        assetFolder.addChild(assetSet)

        // Then
        XCTAssert(assetSet.parent === assetFolder)
        
    }
}
