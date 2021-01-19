import XCTest
@testable import AssetKeyGen

final class ContentTreeTests: XCTestCase {
    func test_fullName_noNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        XCTAssertEqual(root.fullName, "root")
        XCTAssertEqual(child.fullName, "child")
        XCTAssertEqual(grandchild.fullName, "grandchild")
    }
    
    func test_fullName_rootNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: true))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        XCTAssertEqual(root.fullName, "root")
        XCTAssertEqual(child.fullName, "root/child")
        XCTAssertEqual(grandchild.fullName, "root/grandchild")
    }
    
    func test_fullName_childNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: true))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        XCTAssertEqual(root.fullName, "root")
        XCTAssertEqual(child.fullName, "child")
        XCTAssertEqual(grandchild.fullName, "child/grandchild")
    }
    
    func test_fullName_rootAndChildNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: true))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: true))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        XCTAssertEqual(root.fullName, "root")
        XCTAssertEqual(child.fullName, "root/child")
        XCTAssertEqual(grandchild.fullName, "root/child/grandchild")
    }
    
    func test_relativePath() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        XCTAssertEqual(root.relativePath, "")
        XCTAssertEqual(child.relativePath, "child")
        XCTAssertEqual(grandchild.relativePath, "child/grandchild.imageset")
    }
    
    func test_toAsset_whenGroup_returnNil() {
        // Given
        let contentTree = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        
        // When
        let asset = contentTree.toAsset()
        
        // Then
        XCTAssertNil(asset)
    }
    
    func test_toAsset_whenAsset_returnAsset() throws {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        
        // When
        let asset = child.toAsset()
        
        // Then
        let unwrappedAsset = try XCTUnwrap(asset)
        XCTAssertEqual(unwrappedAsset.name, "child")
        XCTAssertEqual(unwrappedAsset.path, "child.imageset")
        XCTAssertEqual(unwrappedAsset.type, .imageSet)
    }
}
