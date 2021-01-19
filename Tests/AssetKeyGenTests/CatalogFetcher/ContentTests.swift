import XCTest
import SampleData
@testable import AssetKeyGen

final class ContentTests: XCTestCase {
    func test_initWithURL_folder() throws {
        // Given
        let url = SampleData.assetURL("Settings")
        
        // When
        let content = try Content(url: url)
        
        // Then
        XCTAssertEqual(content.type, .group)
        XCTAssertEqual(content.providesNamespace, false)
        XCTAssertEqual(content.name, "Settings")
    }
    
    func test_initWithURL_namespaceFolder() throws {
        // Given
        let url = SampleData.assetURL("Places/Dot")
        
        // When
        let content = try Content(url: url)
        
        // Then
        XCTAssertEqual(content.type, .group)
        XCTAssertEqual(content.providesNamespace, true)
        XCTAssertEqual(content.name, "Dot")
    }
    
    func test_initWithURL_imageSet() throws {
        // Given
        let url = SampleData.assetURL("Settings/settingsRate.imageset")
        
        // When
        let content = try Content(url: url)
        
        // Then
        XCTAssertEqual(content.type, .asset(.imageSet))
        XCTAssertEqual(content.providesNamespace, false)
        XCTAssertEqual(content.name, "settingsRate")
    }
    
    func test_initWithURL_colorSet() throws {
        // Given
        let url = SampleData.assetURL("Color/battleshipGrey8.colorset")
        
        // When
        let content = try Content(url: url)
        
        // Then
        XCTAssertEqual(content.type, .asset(.colorSet))
        XCTAssertEqual(content.providesNamespace, false)
        XCTAssertEqual(content.name, "battleshipGrey8")
    }
}
