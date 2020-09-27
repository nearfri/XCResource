import XCTest
@testable import AssetKeyGen

final class ActualKeyListGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let catalogs: [AssetCatalog] = [
            AssetCatalog(
                name: "Media.xcassets",
                assets: [
                    Asset(name: "buttonSelect", path: "Common/Buttons"),
                    Asset(name: "checkIcon", path: "Common/Icons")
                ]),
            AssetCatalog(
                name: "Extra.xcassets",
                assets: [
                    Asset(name: "dice", path: "Toy/Cube"),
                    Asset(name: "dolphin", path: "Animal/Sea")
                ]),
        ]
        let keyTypeName = "ImageKey"
        
        let expectedList = """
        extension ImageKey {
            static let allGeneratedKeys: [ImageKey] = [
                // MARK: Media.xcassets
                .buttonSelect,
                .checkIcon,
                
                // MARK: Extra.xcassets
                .dice,
                .dolphin,
            ]
        }
        """
        
        let sut = ActualKeyListGenerator()
        
        // When
        let actualList = sut.generate(from: catalogs, keyTypeName: keyTypeName)
        
        // Then
        XCTAssertEqual(actualList, expectedList)
    }
}
