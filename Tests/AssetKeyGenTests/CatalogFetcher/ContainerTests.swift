import XCTest
import SampleData
@testable import AssetKeyGen

final class ContainerRecordTests: XCTestCase {
    func test_initContentsOf_folder() throws {
        // Given
        let url = SampleData.assetURL("Settings")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .group)
        XCTAssertEqual(container.providesNamespace, false)
        XCTAssertEqual(container.name, "Settings")
    }
    
    func test_initContentsOf_namespaceFolder() throws {
        // Given
        let url = SampleData.assetURL("Places/Dot")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .group)
        XCTAssertEqual(container.providesNamespace, true)
        XCTAssertEqual(container.name, "Dot")
    }
    
    func test_initContentsOf_imageSet() throws {
        // Given
        let url = SampleData.assetURL("Settings/settingsRate.imageset")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .asset(.imageSet))
        XCTAssertEqual(container.providesNamespace, false)
        XCTAssertEqual(container.name, "settingsRate")
    }
    
    func test_initContentsOf_colorSet() throws {
        // Given
        let url = SampleData.assetURL("Color/battleshipGrey8.colorset")
        
        // When
        let container = try Container(contentsOf: url)
        
        // Then
        XCTAssertEqual(container.type, .asset(.colorSet))
        XCTAssertEqual(container.providesNamespace, false)
        XCTAssertEqual(container.name, "battleshipGrey8")
    }
}
