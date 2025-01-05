import Testing
import SwiftSyntax
@testable import LocStringResourceGen

@Suite struct ExprTests {
    private typealias BundleDesc = LocalizationItem.BundleDescription
    
    @Test func initWithBundle_main() throws {
        #expect(ExprSyntax(BundleDesc.main).description == ".main")
    }
    
    @Test func initWithBundle_atURL() throws {
        #expect(ExprSyntax(BundleDesc.atURL(".moduleURL")).description == ".atURL(.moduleURL)")
    }
    
    @Test func initWithBundle_forClass() throws {
        #expect(ExprSyntax(BundleDesc.forClass("ResourceBundleClass.self")).description ==
                ".forClass(ResourceBundleClass.self)")
    }
}
