import XCTest
import SwiftSyntax
@testable import LocStringResourceGen

final class VariableDeclSyntaxTests: XCTestCase {
    func test_initWithLocalizationItem() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: "Hello world",
            table: "LocalizableSystem",
            bundle: .forClass("ResourceBundleClass.self"),
            memberDeclation: .property("someVariable"))
        
        XCTAssertEqual(VariableDeclSyntax(localizationItem).description, """
            /// Hello world
            static var someVariable: Self {
                .init("some_key",
                      defaultValue: "Hello world",
                      table: "LocalizableSystem",
                      bundle: .forClass(ResourceBundleClass.self))
            }
            """)
    }
}
