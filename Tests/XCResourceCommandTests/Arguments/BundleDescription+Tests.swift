import XCTest
import LocStringResourceGen
@testable import XCResourceCommand

final class BundleDescriptionTests: XCTestCase {
    private typealias BundleDescription = LocalizationItem.BundleDescription
    
    func test_initWithArgument_main() throws {
        XCTAssertEqual(BundleDescription(argument: "main"), .main)
    }
    
    func test_initWithArgument_atURL() throws {
        XCTAssertEqual(BundleDescription(argument: "at-url:.moduleURL"), .atURL(".moduleURL"))
    }
    
    func test_initWithArgument_forClass() throws {
        XCTAssertEqual(BundleDescription(argument: "for-class:ResourceBundleClass.self"),
                       .forClass("ResourceBundleClass.self"))
    }
}
