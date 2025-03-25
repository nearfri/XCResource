import Testing
import SwiftSyntax
@testable import LocStringResourceGen

@Suite struct ExprTests {
    private typealias BundleDesc = LocalizationItem.BundleDescription
    
    @Test func initWithBundle_main() throws {
        #expect(ExprSyntax(BundleDesc.main).description == ".main")
    }
    
    @Test func initWithBundle_atURL() throws {
        let bundle = BundleDesc(rawValue: ".atURL(.moduleURL)")
        #expect(ExprSyntax(bundle).description == ".atURL(.moduleURL)")
    }
    
    @Test func initWithBundle_forClass() throws {
        let bundle = BundleDesc(rawValue: ".forClass(ResourceBundleClass.self)")
        #expect(ExprSyntax(bundle).description == ".forClass(ResourceBundleClass.self)")
    }
}
