import XCTest
import TestUtil
@testable import LocStringResourceGen

final class SwiftLocalizationSourceCodeRewriterTests: XCTestCase {
    func test_rewrite_replaceItems() throws {
        // Given
        let originalSourceCode = """
            import Foundation
            
            private class ResourceBundleClass {}
            
            extension CustomClass {
                // custom code
            }
            
            extension LocalizedStringResource {
                /// Bold
                static var bold: Self {
                    .init("bold",
                          defaultValue: "Bold",
                          table: "TextSystem",
                          bundle: .forClass(ResourceBundleClass.self))
                }
            }
            
            """
        
        let items: [LocalizationItem] = [
            .init(key: "italic",
                  defaultValue: "Italic",
                  table: "TextSystem",
                  bundle: .forClass("ResourceBundleClass.self"), 
                  memberDeclation: .property("italic")),
            .init(key: "underline",
                  defaultValue: "Underline",
                  table: "TextSystem",
                  bundle: .forClass("ResourceBundleClass.self"),
                  memberDeclation: .property("underline")),
        ]
        
        let sut = SwiftLocalizationSourceCodeRewriter()
        
        // When
        let rewritedSourceCode = sut.rewrite(sourceCode: originalSourceCode,
                                             with: items,
                                             resourceTypeName: "LocalizedStringResource")
        
        // Then
        XCTAssertEqual(rewritedSourceCode.description, """
            import Foundation
            
            private class ResourceBundleClass {}
            
            extension CustomClass {
                // custom code
            }
            
            extension LocalizedStringResource {
                /// Italic
                static var italic: Self {
                    .init("italic",
                          defaultValue: "Italic",
                          table: "TextSystem",
                          bundle: .forClass(ResourceBundleClass.self))
                }
                
                /// Underline
                static var underline: Self {
                    .init("underline",
                          defaultValue: "Underline",
                          table: "TextSystem",
                          bundle: .forClass(ResourceBundleClass.self))
                }
            }
            
            """)
    }
    
    func test_rewrite_replaceItems_noExtension_insertNew() throws {
        // Given
        let originalSourceCode = """
            import Foundation
            
            private class ResourceBundleClass {}
            
            extension CustomClass {
                // custom code
            }
            
            """
        
        let items: [LocalizationItem] = [
            .init(key: "italic",
                  defaultValue: "Italic",
                  table: "TextSystem",
                  bundle: .forClass("ResourceBundleClass.self"),
                  memberDeclation: .property("italic")),
        ]
        
        let sut = SwiftLocalizationSourceCodeRewriter()
        
        // When
        let rewritedSourceCode = sut.rewrite(sourceCode: originalSourceCode,
                                             with: items,
                                             resourceTypeName: "LocalizedStringResource")
        
        // Then
        XCTAssertEqual(rewritedSourceCode.description, """
            import Foundation
            
            private class ResourceBundleClass {}
            
            extension CustomClass {
                // custom code
            }
            
            extension LocalizedStringResource {
                /// Italic
                static var italic: Self {
                    .init("italic",
                          defaultValue: "Italic",
                          table: "TextSystem",
                          bundle: .forClass(ResourceBundleClass.self))
                }
            }
            
            """)
    }
}
