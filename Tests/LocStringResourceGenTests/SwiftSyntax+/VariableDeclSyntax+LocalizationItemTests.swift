import Testing
import SwiftSyntax
@testable import LocStringResourceGen

@Suite struct VariableDeclSyntaxTests {
    @Test func initWithLocalizationItem() throws {
        let localizationItem = LocalizationItem(
            key: "some_key",
            defaultValue: "Hello world",
            rawDefaultValue: "",
            table: "LocalizableSystem",
            bundle: ".forClass(ResourceBundleClass.self)",
            attributes: ["@available(*, deprecated)", "@CustomAttribute"],
            memberDeclaration: .property("someVariable"))
        
        #expect(VariableDeclSyntax(localizationItem).description == """
            /// Hello world
            @available(*, deprecated)
            @CustomAttribute
            static var someVariable: Self {
                .init("some_key",
                      defaultValue: "Hello world",
                      table: "LocalizableSystem",
                      bundle: .forClass(ResourceBundleClass.self))
            }
            """)
    }
}
