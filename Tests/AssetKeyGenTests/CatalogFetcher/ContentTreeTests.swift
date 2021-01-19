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
    
    func test_groupsByType() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let image = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child1.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        let color = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child2.colorset"),
                type: .asset(.colorSet),
                providesNamespace: false))
        
        root.addChild(image)
        root.addChild(color)
        
        // When
        let groupsByType = root.makePreOrderSequence().groupsByType()
        
        // Then
        XCTAssertEqual(groupsByType.count, 3)
        XCTAssertEqual(groupsByType[.group]?.count, 1)
        XCTAssertEqual(groupsByType[.asset(.imageSet)]?.count, 1)
        XCTAssertEqual(groupsByType[.asset(.colorSet)]?.count, 1)
        XCTAssertNil(groupsByType[.asset(.symbolSet)])
    }
    
    func test_assetGroupsByType() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let image = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child1.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        let color = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child2.colorset"),
                type: .asset(.colorSet),
                providesNamespace: false))
        
        root.addChild(image)
        root.addChild(color)
        
        // When
        let assetGroupsByType = root.makePreOrderSequence().assetGroupsByType()
        
        // Then
        XCTAssertEqual(assetGroupsByType.count, 2)
        XCTAssertEqual(assetGroupsByType[.imageSet]?.count, 1)
        XCTAssertEqual(assetGroupsByType[.colorSet]?.count, 1)
        XCTAssertNil(assetGroupsByType[.symbolSet])
    }
}
