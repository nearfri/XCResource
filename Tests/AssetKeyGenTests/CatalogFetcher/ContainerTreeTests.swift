import XCTest
@testable import AssetKeyGen

final class ContainerTreeTests: XCTestCase {
    func test_fullName_noNamespace() {
        // Given
        let root = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "root"),
                type: .folder,
                providesNamespace: false))
        let child = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child"),
                type: .folder,
                providesNamespace: false))
        let grandchild = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .imageSet,
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
        let root = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "root"),
                type: .folder,
                providesNamespace: true))
        let child = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child"),
                type: .folder,
                providesNamespace: false))
        let grandchild = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .imageSet,
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
        let root = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "root"),
                type: .folder,
                providesNamespace: false))
        let child = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child"),
                type: .folder,
                providesNamespace: true))
        let grandchild = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .imageSet,
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
        let root = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "root"),
                type: .folder,
                providesNamespace: true))
        let child = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child"),
                type: .folder,
                providesNamespace: true))
        let grandchild = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .imageSet,
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
        let root = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "root"),
                type: .folder,
                providesNamespace: false))
        let child = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child"),
                type: .folder,
                providesNamespace: false))
        let grandchild = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .imageSet,
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
        let root = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "root"),
                type: .folder,
                providesNamespace: false))
        let image = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child1.imageset"),
                type: .imageSet,
                providesNamespace: false))
        let color = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child2.imageset"),
                type: .colorSet,
                providesNamespace: false))
        
        root.addChild(image)
        root.addChild(color)
        
        // When
        let groupsByType = root.makePreOrderSequence().groupsByType()
        
        // Then
        XCTAssertEqual(groupsByType.count, 3)
        XCTAssertEqual(groupsByType[.folder]?.count, 1)
        XCTAssertEqual(groupsByType[.imageSet]?.count, 1)
        XCTAssertEqual(groupsByType[.colorSet]?.count, 1)
        XCTAssertNil(groupsByType[.symbolSet])
    }
    
    func test_assetGroupsByType() {
        // Given
        let root = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "root"),
                type: .folder,
                providesNamespace: false))
        let image = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child1.imageset"),
                type: .imageSet,
                providesNamespace: false))
        let color = ContainerTree(
            Container(
                url: URL(fileURLWithPath: "child2.imageset"),
                type: .colorSet,
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
