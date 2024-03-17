import XCTest
import SwiftSyntax
@testable import LocStringResourceGen

final class FunctionDeclSyntaxTests: XCTestCase {
    func test_initWithLocalizationItem() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: "Hello world",
            table: "LocalizableSystem",
            bundle: .forClass("ResourceBundleClass.self"),
            memberDeclation: .method("someFunction", [
                .init(firstName: "count1", type: "Int"),
                .init(firstName: "count2", type: "Int")
            ]))
        
        XCTAssertEqual(FunctionDeclSyntax(localizationItem).description, """
            /// Hello world
            static func someFunction(count1: Int, count2: Int) -> Self {
                .init("some_key",
                      defaultValue: "Hello world",
                      table: "LocalizableSystem",
                      bundle: .forClass(ResourceBundleClass.self))
            }
            """)
    }
    
    func test_initWithLocalizationItem_manyParameters_returnMultilineSignature() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: "Hello world",
            table: "LocalizableSystem",
            bundle: .forClass("ResourceBundleClass.self"),
            memberDeclation: .method("someFunction", [
                .init(firstName: "name", type: "String"),
                .init(firstName: "count1", type: "Int", defaultValue: "1"),
                .init(firstName: "count2", type: "Int", defaultValue: "2"),
                .init(firstName: "count3", type: "Int", defaultValue: "3"),
            ]))
        
        XCTAssertEqual(FunctionDeclSyntax(localizationItem).description, """
            /// Hello world
            static func someFunction(
                name: String,
                count1: Int = 1,
                count2: Int = 2,
                count3: Int = 3
            ) -> Self {
                .init("some_key",
                      defaultValue: "Hello world",
                      table: "LocalizableSystem",
                      bundle: .forClass(ResourceBundleClass.self))
            }
            """)
    }
}
