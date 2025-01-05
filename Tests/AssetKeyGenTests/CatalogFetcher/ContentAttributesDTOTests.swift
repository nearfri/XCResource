import Testing
import Foundation
@testable import AssetKeyGen

@Suite struct ContentAttributesDTOTests {
    @Test func initFromDecoder_folder() throws {
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
        #expect(content.properties == nil)
    }
    
    @Test func initFromDecoder_namespaceFolder() throws {
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
        #expect(content.properties?.providesNamespace == true)
    }
}
