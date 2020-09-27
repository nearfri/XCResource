import XCTest
@testable import AssetKeyGen

final class ContainerRecordTests: XCTestCase {
    func test_initContentsOf_folder() throws {
        // Given
        let url = assetURL("Common")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .folder)
        XCTAssertEqual(container.providesNamespace, false)
        XCTAssertEqual(container.name, "Common")
    }
    
    func test_initContentsOf_namespaceFolder() throws {
        // Given
        let url = assetURL("Common/ClipListView")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .folder)
        XCTAssertEqual(container.providesNamespace, true)
        XCTAssertEqual(container.name, "ClipListView")
    }
    
    func test_initContentsOf_imageSet() throws {
        // Given
        let url = assetURL("Common/btnSelect.imageset")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .imageSet)
        XCTAssertEqual(container.providesNamespace, false)
        XCTAssertEqual(container.name, "btnSelect")
    }
    
    func test_initContentsOf_colorSet() throws {
        // Given
        let url = assetURL("Color/battleshipGrey8.colorset")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .colorSet)
        XCTAssertEqual(container.providesNamespace, false)
        XCTAssertEqual(container.name, "battleshipGrey8")
    }
}