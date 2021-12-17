import XCTest
@testable import AssetKeyGen

private enum Seed {
    static let catalog = AssetCatalog(
        name: "Media.xcassets",
        assets: [
            Asset(name: "buttonSelect",
                  path: "Common/Buttons/buttonSelect.imageset",
                  type: .imageSet),
            Asset(name: "checkIcon",
                  path: "Common/Icons/checkIcon.imageset",
                  type: .imageSet)
        ])
}

final class DefaultKeyDeclarationGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
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
        let actualDeclations = sut.generate(catalog: Seed.catalog,
                                            keyTypeName: "ImageKey",
                                            accessLevel: nil)
        
        // Then
        XCTAssertEqual(actualDeclations, expectedDeclations)
    }
    
    func test_generate_publicAccessLevel() {
        // Given
        let expectedDeclations = """
        // MARK: - Media.xcassets
        
        public extension ImageKey {
            // MARK: Common/Buttons
            static let buttonSelect: ImageKey = "buttonSelect"
            
            // MARK: Common/Icons
            static let checkIcon: ImageKey = "checkIcon"
        }
        """
        
        let sut = DefaultKeyDeclarationGenerator()
        
        // When
        let actualDeclations = sut.generate(catalog: Seed.catalog,
                                            keyTypeName: "ImageKey",
                                            accessLevel: "public")
        
        // Then
        XCTAssertEqual(actualDeclations, expectedDeclations)
    }
}
