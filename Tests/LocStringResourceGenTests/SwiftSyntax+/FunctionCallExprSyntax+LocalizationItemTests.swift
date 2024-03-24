import XCTest
import SwiftSyntax
@testable import LocStringResourceGen

final class FunctionCallExprSyntaxTests: XCTestCase {
    func test_initWithLocalizationItem() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: #"This file is \(fileSize) bytes."#,
            rawDefaultValue: "",
            memberDeclation: .method("some_key", [.init(firstName: "fileSize", type: "Int")]))
        
        XCTAssertEqual(FunctionCallExprSyntax(localizationItem).description, #"""
            .init("some_key",
                  defaultValue: "This file is \(fileSize) bytes.")
            """#)
    }
    
    func test_initWithLocalizationItem_withTable() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: #"This file is \(fileSize) bytes."#,
            rawDefaultValue: "",
            table: "LocalizableSystem",
            memberDeclation: .method("some_key", [.init(firstName: "fileSize", type: "Int")]))
        
        XCTAssertEqual(FunctionCallExprSyntax(localizationItem).description, #"""
            .init("some_key",
                  defaultValue: "This file is \(fileSize) bytes.",
                  table: "LocalizableSystem")
            """#)
    }
    
    func test_initWithLocalizationItem_withBundle() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: #"This file is \(fileSize) bytes."#,
            rawDefaultValue: "",
            bundle: .forClass("ResourceBundleClass.self"),
            memberDeclation: .method("some_key", [.init(firstName: "fileSize", type: "Int")]))
        
        XCTAssertEqual(FunctionCallExprSyntax(localizationItem).description, #"""
            .init("some_key",
                  defaultValue: "This file is \(fileSize) bytes.",
                  bundle: .forClass(ResourceBundleClass.self))
            """#)
    }
    
    func test_initWithLocalizationItem_multilineDefaultValue() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: "Hello\nWorld!",
            rawDefaultValue: "",
            bundle: .forClass("ResourceBundleClass.self"),
            memberDeclation: .property("some_key"))
        
        XCTAssertEqual(FunctionCallExprSyntax(localizationItem).description, #"""
            .init("some_key",
                  defaultValue: """
                    Hello
                    World!
                    """,
                  bundle: .forClass(ResourceBundleClass.self))
            """#)
    }
}
