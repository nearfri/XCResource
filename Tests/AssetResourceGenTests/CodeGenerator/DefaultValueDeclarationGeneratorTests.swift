import Testing
import Foundation
import TestUtil
@testable import AssetResourceGen

private enum Fixture {
    static var contentTree: ContentTree {
        ContentTree(Content(url: URL(filePath: "Media.xcassets"), type: .group), children: [
            ContentTree(
                Content(
                    url: URL(filePath: "Media.xcassets/Buttons"),
                    type: .group,
                    providesNamespace: true),
                children: [
                    ContentTree(Content(url: URL(filePath: "Media.xcassets/Buttons/done.imageset"),
                                        type: .asset(.imageSet)))
                ]),
            ContentTree(
                Content(
                    url: URL(filePath: "Media.xcassets/Icons"),
                    type: .group,
                    providesNamespace: false),
                children: [
                    ContentTree(Content(url: URL(filePath: "Media.xcassets/Icons/check.imageset"),
                                        type: .asset(.imageSet)))
                ]),
        ])
    }
}

@Suite struct DefaultValueDeclarationGeneratorTests {
    @Test func generate() {
        // Given
        let expectedDeclarations = """
        // MARK: - Media.xcassets
        
        extension ImageKey {
            enum Buttons {
                static let done: ImageKey = .init(
                    name: "Buttons/done",
                    bundle: Bundle.main)
            }
            
            static let check: ImageKey = .init(
                name: "check",
                bundle: Bundle.main)
        }
        """
        
        let sut = DefaultValueDeclarationGenerator()
        
        // When
        let actualDeclarations = sut.generate(for: ValueDeclarationRequest(
            contentTree: Fixture.contentTree,
            resourceTypeName: "ImageKey",
            bundle: "Bundle.main"))
        
        // Then
        expectEqual(actualDeclarations, expectedDeclarations)
    }
    
    @Test func generate_publicAccessLevel() {
        // Given
        let expectedDeclarations = """
        // MARK: - Media.xcassets
        
        extension ImageKey {
            public enum Buttons {
                public static let done: ImageKey = .init(
                    name: "Buttons/done",
                    bundle: Bundle.main)
            }
            
            public static let check: ImageKey = .init(
                name: "check",
                bundle: Bundle.main)
        }
        """
        
        let sut = DefaultValueDeclarationGenerator()
        
        // When
        let actualDeclarations = sut.generate(for: ValueDeclarationRequest(
            contentTree: Fixture.contentTree,
            resourceTypeName: "ImageKey",
            bundle: "Bundle.main",
            accessLevel: "public"))
        
        // Then
        expectEqual(actualDeclarations, expectedDeclarations)
    }
}
