import Testing
import SwiftSyntax
@testable import LocStringResourceGen

@Suite struct FunctionCallExprSyntaxTests {
    @Test func initWithLocalizationItem() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: #"This file is \(fileSize) bytes."#,
            rawDefaultValue: "",
            memberDeclaration: .method("some_key", [.init(firstName: "fileSize", type: "Int")]))
        
        #expect(FunctionCallExprSyntax(localizationItem).description == #"""
            .init("some_key",
                  defaultValue: "This file is \(fileSize) bytes.")
            """#)
    }
    
    @Test func initWithLocalizationItem_withTable() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: #"This file is \(fileSize) bytes."#,
            rawDefaultValue: "",
            table: "LocalizableSystem",
            memberDeclaration: .method("some_key", [.init(firstName: "fileSize", type: "Int")]))
        
        #expect(FunctionCallExprSyntax(localizationItem).description == #"""
            .init("some_key",
                  defaultValue: "This file is \(fileSize) bytes.",
                  table: "LocalizableSystem")
            """#)
    }
    
    @Test func initWithLocalizationItem_withBundle() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: #"This file is \(fileSize) bytes."#,
            rawDefaultValue: "",
            bundle: .forClass("ResourceBundleClass.self"),
            memberDeclaration: .method("some_key", [.init(firstName: "fileSize", type: "Int")]))
        
        #expect(FunctionCallExprSyntax(localizationItem).description == #"""
            .init("some_key",
                  defaultValue: "This file is \(fileSize) bytes.",
                  bundle: .forClass(ResourceBundleClass.self))
            """#)
    }
    
    @Test func initWithLocalizationItem_multilineDefaultValue() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: "Hello\nWorld!",
            rawDefaultValue: "",
            bundle: .forClass("ResourceBundleClass.self"),
            memberDeclaration: .property("some_key"))
        
        #expect(FunctionCallExprSyntax(localizationItem).description == #"""
            .init("some_key",
                  defaultValue: """
                    Hello
                    World!
                    """,
                  bundle: .forClass(ResourceBundleClass.self))
            """#)
    }
}
