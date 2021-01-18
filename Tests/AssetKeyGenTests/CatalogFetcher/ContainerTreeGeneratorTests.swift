import XCTest
import SampleData
@testable import AssetKeyGen

final class ContainerTreeGeneratorTests: XCTestCase {
    func test_load_root() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        
        // Then
        XCTAssert(root.isRoot)
        XCTAssert(root.hasChildren)
        XCTAssertEqual(root.element.name, url.lastPathComponent)
        XCTAssertEqual(root.element.type, .group)
        XCTAssertEqual(root.element.providesNamespace, false)
    }
    
    func test_load_childFolder() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        let c1 = try XCTUnwrap(root.children.first(where: { $0.element.name == "Places" }))
        let c2 = try XCTUnwrap(c1.children.first(where: { $0.element.name == "Dot" }))
        
        // Then
        XCTAssertFalse(c1.isRoot)
        XCTAssertFalse(c2.isRoot)
        
        XCTAssert(c1.hasChildren)
        XCTAssert(c2.hasChildren)
        
        XCTAssertEqual(c1.element.name, "Places")
        XCTAssertEqual(c2.element.name, "Dot")
        
        XCTAssertEqual(c1.element.type, .group)
        XCTAssertEqual(c2.element.type, .group)
        
        XCTAssertEqual(c1.element.providesNamespace, false)
        XCTAssertEqual(c2.element.providesNamespace, true)
    }
    
    func test_load_imageSet() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        let folder = try XCTUnwrap(root.children.first(where: { $0.element.name == "Settings" }))
        let image = try XCTUnwrap(folder.children.first(where: { $0.element.name == "settings" }))
        
        // Then
        XCTAssertFalse(image.hasChildren)
        XCTAssertEqual(image.element.name, "settings")
        XCTAssertEqual(image.element.type, .asset(.imageSet))
        XCTAssertEqual(image.element.providesNamespace, false)
    }
    
    func test_load_colorSet() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try ContainerTreeGenerator().load(contentsOf: url)
        let folder = try XCTUnwrap(root.children.first(where: { $0.element.name == "Color" }))
        let color = try XCTUnwrap(folder.children.first(where: { $0.element.name == "blush" }))
        
        // Then
        XCTAssertFalse(color.hasChildren)
        XCTAssertEqual(color.element.name, "blush")
        XCTAssertEqual(color.element.type, .asset(.colorSet))
        XCTAssertEqual(color.element.providesNamespace, false)
    }
}
