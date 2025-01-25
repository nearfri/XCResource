import Testing
import LocStringResourceGen
@testable import XCResourceCommand

@Suite struct BundleDescriptionTests {
    private typealias BundleDescription = LocalizationItem.BundleDescription
    
    @Test func initWithArgument_main() throws {
        #expect(BundleDescription(argument: "main") == .main)
    }
    
    @Test func initWithArgument_atURL() throws {
        #expect(BundleDescription(argument: "atURL:.moduleURL") == .atURL(".moduleURL"))
    }
    
    @Test func initWithArgument_forClass() throws {
        #expect(BundleDescription(argument: "forClass:ResourceBundleClass.self") ==
            .forClass("ResourceBundleClass.self"))
    }
}
