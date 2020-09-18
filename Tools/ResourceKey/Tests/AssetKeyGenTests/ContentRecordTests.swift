import XCTest
@testable import AssetKeyGen

final class ContentRecordTests: XCTestCase {
    func test_initFromDecoder_folder() throws {
        // When
        let content = try JSONDecoder().decode(ContentRecord.self, from: Seed.folderJSON)
        
        // Then
        XCTAssertNil(content.type)
        XCTAssertNil(content.properties)
    }
    
    func test_initFromDecoder_namespaceFolder() throws {
        // When
        let content = try JSONDecoder().decode(ContentRecord.self, from: Seed.namespaceFolderJSON)
        
        // Then
        XCTAssertNil(content.type)
        XCTAssertEqual(content.properties?.providesNamespace, true)
    }
    
    func test_initFromDecoder_onDemandFolder() throws {
        // When
        let content = try JSONDecoder().decode(ContentRecord.self, from: Seed.onDemandFolderJSON)
        
        // Then
        XCTAssertNil(content.type)
        XCTAssertNotNil(content.properties)
        XCTAssertNil(content.properties?.providesNamespace)
    }
    
    func test_initFromDecoder_image() throws {
        // When
        let content = try JSONDecoder().decode(ContentRecord.self, from: Seed.imageJSON)
        
        // Then
        XCTAssertEqual(content.type, .imageSet)
        XCTAssertNil(content.properties)
    }
    
    func test_initFromDecoder_color() throws {
        // When
        let content = try JSONDecoder().decode(ContentRecord.self, from: Seed.colorJSON)
        
        // Then
        XCTAssertEqual(content.type, .colorSet)
        XCTAssertNil(content.properties)
    }
}

private enum Seed {
    static let folderJSON = """
    {
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }
    """.data(using: .utf8)!
    
    static let namespaceFolderJSON = """
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
    
    static let onDemandFolderJSON = """
    {
      "info" : {
        "author" : "xcode",
        "version" : 1
      },
      "properties" : {
        "on-demand-resource-tags" : [
          "customTag"
        ]
      }
    }
    """.data(using: .utf8)!
    
    static let imageJSON = """
    {
      "images" : [
        {
          "filename" : "icoClose.png",
          "idiom" : "universal",
          "scale" : "1x"
        },
        {
          "filename" : "icoClose@2x.png",
          "idiom" : "universal",
          "scale" : "2x"
        },
        {
          "filename" : "icoClose@3x.png",
          "idiom" : "universal",
          "scale" : "3x"
        }
      ],
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }
    """.data(using: .utf8)!
    
    static let colorJSON = """
    {
      "colors" : [
        {
          "color" : {
            "color-space" : "srgb",
            "components" : {
              "alpha" : "0.700",
              "blue" : "1.000",
              "green" : "1.000",
              "red" : "1.000"
            }
          },
          "idiom" : "universal"
        }
      ],
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }
    """.data(using: .utf8)!
}
