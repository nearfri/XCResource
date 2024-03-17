import XCTest
import TestUtil
@testable import XCResourceCommand

private enum Fixture {
    static let catalog = """
        {
          "sourceLanguage" : "en",
          "strings" : {
            "cancel" : {
              "comment" : "Cancel",
              "extractionState" : "migrated",
              "localizations" : {
                "en" : {
                  "stringUnit" : {
                    "state" : "translated",
                    "value" : "Cancel"
                  }
                },
                "ko" : {
                  "stringUnit" : {
                    "state" : "translated",
                    "value" : "취소"
                  }
                }
              }
            }
          },
          "version" : "1.0"
        }
        """
    
    static let oldSourceCode = """
        import Foundation
        
        public extension LocalizedStringResource {
        }
        
        """
    
    static let newSourceCode = """
        import Foundation
        
        public extension LocalizedStringResource {
            /// Cancel
            static var cancel: Self {
                .init("cancel",
                      defaultValue: "Cancel")
            }
        }
        
        """
}

final class XCStringsToSwiftTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let catalogURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try Fixture.catalog.write(to: catalogURL, atomically: false, encoding: .utf8)
        try Fixture.oldSourceCode.write(to: sourceCodeURL, atomically: false, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: catalogURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        // When
        try XCStringsToSwift.runAsRoot(arguments: [
            "--catalog-path", catalogURL.path,
            "--swift-path", sourceCodeURL.path,
        ])
        
        // Then
        XCTAssertEqual(try String(contentsOf: sourceCodeURL), Fixture.newSourceCode)
    }
}
