import XCTest
@testable import AssetKeyGen

final class DefaultKeyDeclarationGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let catalog = AssetCatalog(
            name: "Media.xcassets",
            assets: [
                Asset(name: "buttonSelect",
                      path: "Common/Buttons/buttonSelect.imageset",
                      type: .imageSet),
                Asset(name: "checkIcon",
                      path: "Common/Icons/checkIcon.imageset",
                      type: .imageSet)
            ])
        let keyTypeName = "ImageKey"
        
        let expectedDeclations = """
        // MARK: - Media.xcassets
        
        extension ImageKey {
            // MARK: Common/Buttons
            static let buttonSelect: ImageKey = "buttonSelect"
            
            // MARK: Common/Icons
            static let checkIcon: ImageKey = "checkIcon"
        }
        """
        
        let sut = DefaultKeyDeclarationGenerator()
        
        // When
        let actualDeclations = sut.generate(catalog: catalog, keyTypeName: keyTypeName)
        
        // Then
        XCTAssertEqual(actualDeclations, expectedDeclations)
    }
}
