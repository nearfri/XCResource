import Testing
import TestUtil
@testable import AssetKeyGen

private enum Fixture {
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

@Suite struct DefaultKeyDeclarationGeneratorTests {
    @Test func generate() {
        // Given
        let expectedDeclarations = """
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
        let actualDeclarations = sut.generate(catalog: Fixture.catalog,
                                            keyTypeName: "ImageKey",
                                            accessLevel: nil)
        
        // Then
        expectEqual(actualDeclarations, expectedDeclarations)
    }
    
    @Test func generate_publicAccessLevel() {
        // Given
        let expectedDeclarations = """
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
        let actualDeclarations = sut.generate(catalog: Fixture.catalog,
                                            keyTypeName: "ImageKey",
                                            accessLevel: "public")
        
        // Then
        expectEqual(actualDeclarations, expectedDeclarations)
    }
}
