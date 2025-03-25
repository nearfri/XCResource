import Testing
import TestUtil
@testable import LocStringResourceGen

@Suite struct SwiftLocalizationSourceCodeRewriterTests {
    @Test func rewrite_replaceItems() throws {
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
                  rawDefaultValue: "",
                  table: "TextSystem",
                  bundle: ".forClass(ResourceBundleClass.self)",
                  memberDeclaration: .property("italic")),
            .init(key: "underline",
                  defaultValue: "Underline",
                  rawDefaultValue: "",
                  table: "TextSystem",
                  bundle: ".forClass(ResourceBundleClass.self)",
                  memberDeclaration: .property("underline")),
        ]
        
        let sut = SwiftLocalizationSourceCodeRewriter()
        
        // When
        let rewritedSourceCode = sut.rewrite(sourceCode: originalSourceCode,
                                             with: items,
                                             resourceTypeName: "LocalizedStringResource")
        
        // Then
        #expect(rewritedSourceCode.description == """
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
    
    @Test func rewrite_replaceItems_noImportFoundation_insert() throws {
        // Given
        let originalSourceCode = """
            import SwiftUI
            
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
                  rawDefaultValue: "",
                  table: "TextSystem",
                  bundle: ".forClass(ResourceBundleClass.self)",
                  memberDeclaration: .property("italic")),
        ]
        
        let sut = SwiftLocalizationSourceCodeRewriter()
        
        // When
        let rewritedSourceCode = sut.rewrite(sourceCode: originalSourceCode,
                                             with: items,
                                             resourceTypeName: "LocalizedStringResource")
        
        // Then
        #expect(rewritedSourceCode.description == """
            import Foundation
            import SwiftUI
            
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
    
    @Test func rewrite_replaceItems_noExtension_insert() throws {
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
                  rawDefaultValue: "",
                  table: "TextSystem",
                  bundle: ".forClass(ResourceBundleClass.self)",
                  memberDeclaration: .property("italic")),
        ]
        
        let sut = SwiftLocalizationSourceCodeRewriter()
        
        // When
        let rewritedSourceCode = sut.rewrite(sourceCode: originalSourceCode,
                                             with: items,
                                             resourceTypeName: "LocalizedStringResource")
        
        // Then
        #expect(rewritedSourceCode.description == """
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
