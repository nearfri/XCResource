import XCTest
@testable import AssetKeyGen

final class ActualKeyListGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let catalogs: [AssetCatalog] = [
            AssetCatalog(
                name: "Media.xcassets",
                assets: [
                    Asset(name: "buttonSelect", relativePath: "Common/Buttons"),
                    Asset(name: "checkIcon", relativePath: "Common/Icons")
                ]),
            AssetCatalog(
                name: "Extra.xcassets",
                assets: [
                    Asset(name: "dice", relativePath: "Toy/Cube"),
                    Asset(name: "dolphin", relativePath: "Animal/Sea")
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
        \n
        """
        
        let sut = ActualKeyListGenerator()
        
        // When
        let actualList = sut.generate(from: catalogs, keyTypeName: keyTypeName)
        
        // Then
        XCTAssertEqual(actualList, expectedList)
    }
}
