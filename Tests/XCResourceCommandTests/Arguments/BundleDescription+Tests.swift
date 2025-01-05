import Testing
import LocStringResourceGen
@testable import XCResourceCommand

@Suite struct BundleDescriptionTests {
    private typealias BundleDescription = LocalizationItem.BundleDescription
    
    @Test func initWithArgument_main() throws {
        #expect(BundleDescription(argument: "main") == .main)
    }
    
    @Test func initWithArgument_atURL() throws {
        #expect(BundleDescription(argument: "at-url:.moduleURL") == .atURL(".moduleURL"))
    }
    
    @Test func initWithArgument_forClass() throws {
        #expect(BundleDescription(argument: "for-class:ResourceBundleClass.self") ==
            .forClass("ResourceBundleClass.self"))
    }
}
