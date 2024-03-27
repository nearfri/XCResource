import XCTest
import SwiftSyntax
@testable import LocStringResourceGen

final class ExprTests: XCTestCase {
    private typealias BundleDesc = LocalizationItem.BundleDescription
    
    func test_initWithBundle_main() throws {
        XCTAssertEqual(ExprSyntax(BundleDesc.main).description, ".main")
    }
    
    func test_initWithBundle_atURL() throws {
        XCTAssertEqual(ExprSyntax(BundleDesc.atURL(".moduleURL")).description,
                       ".atURL(.moduleURL)")
    }
    
    func test_initWithBundle_forClass() throws {
        XCTAssertEqual(ExprSyntax(BundleDesc.forClass("ResourceBundleClass.self")).description,
                       ".forClass(ResourceBundleClass.self)")
    }
}
