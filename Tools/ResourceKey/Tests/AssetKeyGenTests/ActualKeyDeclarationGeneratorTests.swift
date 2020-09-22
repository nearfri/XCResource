import XCTest
@testable import AssetKeyGen

final class ActualKeyDeclarationGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let catalog = AssetCatalog(
            name: "Media.xcassets",
            assets: [
                Asset(name: "buttonSelect", relativePath: "Common/Buttons"),
                Asset(name: "checkIcon", relativePath: "Common/Icons")
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
        \n
        """
        
        let sut = ActualKeyDeclarationGenerator()
        
        // When
        let actualDeclations = sut.generate(from: catalog, keyTypeName: keyTypeName)
        
        // Then
        XCTAssertEqual(actualDeclations, expectedDeclations)
    }
}
