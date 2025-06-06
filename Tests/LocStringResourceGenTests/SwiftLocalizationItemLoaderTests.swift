import Testing
import SwiftSyntax
import SwiftParser
@testable import LocStringResourceGen

@Suite struct SwiftLocalizationItemLoaderTests {
    @Test func load_property() throws {
        // Given
        let source = """
            import Foundation
            import UIKit
            
            private class FakeClass {}
            
            extension LocalizedStringResource {
            // dev comments
            /// Underline
            static var underline: Self {
                .init("style_underline",
                  defaultValue: "Underline",
                  table: "TextSystem",
                  bundle: .forClass(FakeClass.self))
            }
            
            """
        let sut = SwiftLocalizationItemLoader()
        
        // When
        let items = try sut.load(source: source, resourceTypeName: "LocalizedStringResource")
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "style_underline",
                defaultValue: "Underline",
                rawDefaultValue: "",
                table: "TextSystem",
                bundle: ".forClass(FakeClass.self)",
                developerComments: ["dev comments"],
                memberDeclaration: .property("underline"))
        ])
    }
    
    @Test func load_method() throws {
        // Given
        let source = #"""
            import Foundation
            import UIKit
            
            private class FakeClass {}
            
            extension LocalizedStringResource {
            /// My dog ate \(appleCount) today!
            static func dogEatingApples(appleCount: Int) -> Self {
                .init("dog_eating_apples",
                  defaultValue: "My dog ate \(appleCount) today!",
                  table: "TextSystem",
                  bundle: .forClass(FakeClass.self))
            }
            
            """#
        let sut = SwiftLocalizationItemLoader()
        
        // When
        let items = try sut.load(source: source, resourceTypeName: "LocalizedStringResource")
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "dog_eating_apples",
                defaultValue: #"My dog ate \(appleCount) today!"#,
                rawDefaultValue: "",
                table: "TextSystem",
                bundle: ".forClass(FakeClass.self)",
                memberDeclaration: .method("dogEatingApples", [
                    .init(firstName: "appleCount", type: "Int")
                ]))
        ])
    }
    
    @Test func load_manyItems() throws {
        // Given
        let source = """
            import Foundation
            import UIKit
            
            private class FakeClass {}
            
            extension LocalizedStringResource {
            // dev comments
            /// Underline
            static var underline: Self {
                .init("underline",
                  defaultValue: "Underline",
                  table: "TextSystem",
                  bundle: .forClass(FakeClass.self))
            }
            
            /// Hello
            static var greeting: Self {
                .init("greeting",
                  defaultValue: "Hello",
                  table: "TextSystem",
                  bundle: .forClass(FakeClass.self))
            }
            """
        let sut = SwiftLocalizationItemLoader()
        
        // When
        let items = try sut.load(source: source, resourceTypeName: "LocalizedStringResource")
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "underline",
                defaultValue: "Underline",
                rawDefaultValue: "",
                table: "TextSystem",
                bundle: ".forClass(FakeClass.self)",
                developerComments: ["dev comments"],
                memberDeclaration: .property("underline")),
            LocalizationItem(
                key: "greeting",
                defaultValue: "Hello",
                rawDefaultValue: "",
                table: "TextSystem",
                bundle: ".forClass(FakeClass.self)",
                memberDeclaration: .property("greeting"))
        ])
    }
}
