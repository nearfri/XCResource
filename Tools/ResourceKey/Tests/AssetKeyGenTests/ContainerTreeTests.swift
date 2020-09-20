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
                url: URL(fileURLWithPath: "grandchild"),
                type: .folder,
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
                url: URL(fileURLWithPath: "grandchild"),
                type: .folder,
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
                url: URL(fileURLWithPath: "grandchild"),
                type: .folder,
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
                url: URL(fileURLWithPath: "grandchild"),
                type: .folder,
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
                url: URL(fileURLWithPath: "grandchild"),
                type: .folder,
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        XCTAssertEqual(root.relativePath, "")
        XCTAssertEqual(child.relativePath, "child")
        XCTAssertEqual(grandchild.relativePath, "child/grandchild")
    }
}
