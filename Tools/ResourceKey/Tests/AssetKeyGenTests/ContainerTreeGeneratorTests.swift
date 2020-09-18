import XCTest
import SampleData
@testable import AssetKeyGen

final class ContainerTreeGeneratorTests: XCTestCase {
    func test_load_root() throws {
        // Given
        let url = assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        
        // Then
        XCTAssert(root.isRoot)
        XCTAssert(root.hasChildren)
        XCTAssertEqual(root.element.name, url.lastPathComponent)
        XCTAssertEqual(root.element.type, .folder)
        XCTAssertEqual(root.element.providesNamespace, false)
    }
    
    func test_load_childFolder() throws {
        // Given
        let url = assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        let c1 = try XCTUnwrap(root.children.first(where: { $0.element.name == "Common" }))
        let c2 = try XCTUnwrap(c1.children.first(where: { $0.element.name == "ClipListView" }))
        
        // Then
        XCTAssertFalse(c1.isRoot)
        XCTAssertFalse(c2.isRoot)
        
        XCTAssert(c1.hasChildren)
        XCTAssert(c2.hasChildren)
        
        XCTAssertEqual(c2.element.name, "ClipListView")
        XCTAssertEqual(c2.element.name, "ClipListView")
        
        XCTAssertEqual(c1.element.type, .folder)
        XCTAssertEqual(c2.element.type, .folder)
        
        XCTAssertEqual(c1.element.providesNamespace, false)
        XCTAssertEqual(c2.element.providesNamespace, true)
    }
    
    func test_load_imageSet() throws {
        // Given
        let url = assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        let folder = try XCTUnwrap(root.children.first(where: { $0.element.name == "Common" }))
        let image = try XCTUnwrap(folder.children.first(where: { $0.element.name == "btnSelect" }))
        
        // Then
        XCTAssertFalse(image.hasChildren)
        XCTAssertEqual(image.element.name, "btnSelect")
        XCTAssertEqual(image.element.type, .imageSet)
        XCTAssertEqual(image.element.providesNamespace, false)
    }
    
    func test_load_colorSet() throws {
        // Given
        let url = assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        let folder = try XCTUnwrap(root.children.first(where: { $0.element.name == "Color" }))
        let color = try XCTUnwrap(folder.children.first(where: { $0.element.name == "blush" }))
        
        // Then
        XCTAssertFalse(color.hasChildren)
        XCTAssertEqual(color.element.name, "blush")
        XCTAssertEqual(color.element.type, .colorSet)
        XCTAssertEqual(color.element.providesNamespace, false)
    }
}
