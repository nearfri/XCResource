import XCTest
@testable import AssetKeyGen

final class ContentAttributesDTOTests: XCTestCase {
    func test_initFromDecoder_folder() throws {
        // Given
        let json = """
        {
          "info" : {
            "author" : "xcode",
            "version" : 1
          }
        }
        """.data(using: .utf8)!
        
        // When
        let content = try JSONDecoder().decode(ContentAttributesDTO.self, from: json)
        
        // Then
        XCTAssertNil(content.properties)
    }
    
    func test_initFromDecoder_namespaceFolder() throws {
        // Given
        let json = """
        {
          "info" : {
            "author" : "xcode",
            "version" : 1
          },
          "properties" : {
            "provides-namespace" : true
          }
        }
        """.data(using: .utf8)!
        
        // When
        let content = try JSONDecoder().decode(ContentAttributesDTO.self, from: json)
        
        // Then
        XCTAssertEqual(content.properties?.providesNamespace, true)
    }
}
