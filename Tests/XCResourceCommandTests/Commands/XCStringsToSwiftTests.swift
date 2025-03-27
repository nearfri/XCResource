import Testing
import Foundation
import TestUtil
@testable import XCResourceCommand

private enum Fixture {
    static let catalog = """
        {
          "sourceLanguage" : "en",
          "strings" : {
            "alert_delete_file" : {
              "localizations" : {
                "en" : {
                  "stringUnit" : {
                    "state" : "translated",
                    "value" : "\\"%@\\" will be deleted.\\nThis action cannot be undone."
                  }
                }
              }
            },
            "cancel" : {
              "comment" : "Cancellation",
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
    
    static let initialNewSourceCode = """
        import Foundation
        
        extension LocalizedStringResource {
            /// \\"\\\\(param1)\\" will be deleted.\\
            /// This action cannot be undone.
            static func alertDeleteFile(_ param1: String) -> Self {
                .init("alert_delete_file",
                      defaultValue: \"\"\"
                        \\"\\(param1)\\" will be deleted.
                        This action cannot be undone.
                        \"\"\",
                      table: "CustomLocalizable",
                      bundle: .forClass(BundleFinder.self))
            }
            
            /// Cancel
            ///
            /// Cancellation
            static var cancel: Self {
                .init("cancel",
                      defaultValue: "Cancel",
                      table: "CustomLocalizable",
                      bundle: .forClass(BundleFinder.self),
                      comment: "Cancellation")
            }
        }
        
        """
    
    static let oldSourceCode = """
        import Foundation
        
        public extension LocalizedStringResource {
            /// "\\\\(filename)" will be deleted.\\
            /// This action cannot be undone.
            static func alertDeleteFile(filename: String) -> Self {
                .init("alert_delete_file",
                      defaultValue: \"\"\"
                        "\\(filename)" will be deleted.
                        This action cannot be undone.
                        \"\"\",
                      table: "CustomLocalizable",
                      bundle: .forClass(BundleFinder.self))
            }
        }
        
        """
    
    static let newSourceCode = """
        import Foundation
        
        public extension LocalizedStringResource {
            /// \\"\\\\(filename)\\" will be deleted.\\
            /// This action cannot be undone.
            static func alertDeleteFile(filename: String) -> Self {
                .init("alert_delete_file",
                      defaultValue: \"\"\"
                        \\"\\(filename)\\" will be deleted.
                        This action cannot be undone.
                        \"\"\",
                      table: "CustomLocalizable",
                      bundle: .forClass(BundleFinder.self))
            }
            
            /// Cancel
            ///
            /// Cancellation
            static var cancel: Self {
                .init("cancel",
                      defaultValue: "Cancel",
                      table: "CustomLocalizable",
                      bundle: .forClass(BundleFinder.self),
                      comment: "Cancellation")
            }
        }
        
        """
}

@Suite struct XCStringsToSwiftTests {
    @Test func runAsRoot_initial() throws {
        // Given
        let fm = FileManager.default
        
        let catalogURL = fm.temporaryDirectory.appendingPathComponent("CustomLocalizable.xcstrings")
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try Fixture.catalog.write(to: catalogURL, atomically: false, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: catalogURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        // When
        try XCStringsToSwift.runAsRoot(arguments: [
            "--catalog-path", catalogURL.path,
            "--swift-file-path", sourceCodeURL.path,
            "--bundle", ".forClass(BundleFinder.self)",
        ])
        
        // Then
        expectEqual(try String(contentsOf: sourceCodeURL, encoding: .utf8),
                    Fixture.initialNewSourceCode)
    }
    
    @Test func runAsRoot_update() throws {
        // Given
        let fm = FileManager.default
        
        let catalogURL = fm.temporaryDirectory.appendingPathComponent("CustomLocalizable.xcstrings")
        
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
            "--swift-file-path", sourceCodeURL.path,
            "--bundle", ".forClass(BundleFinder.self)",
        ])
        
        // Then
        expectEqual(try String(contentsOf: sourceCodeURL, encoding: .utf8), Fixture.newSourceCode)
    }
}
