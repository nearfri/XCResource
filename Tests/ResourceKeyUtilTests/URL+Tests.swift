import XCTest
@testable import ResourceKeyUtil

final class URLTests: XCTestCase {
    func test_initWithFileURLWithExpandingTildeInPath() throws {
        let homeURL = URL(fileURLWithPath: ("~" as NSString).expandingTildeInPath)
        XCTAssert(homeURL.path.count > 1)
        
        XCTAssertEqual(URL(fileURLWithExpandingTildeInPath: "~"), homeURL)
        
        XCTAssertEqual(URL(fileURLWithExpandingTildeInPath: "~/hello/world"),
                       homeURL.appendingPathComponent("hello/world"))
        
        XCTAssertEqual(URL(fileURLWithExpandingTildeInPath: "~hello/world"),
                       URL(fileURLWithPath: "~hello/world"))
        
        XCTAssertEqual(URL(fileURLWithExpandingTildeInPath: "hello/world"),
                       URL(fileURLWithPath: "hello/world"))
        
        XCTAssertEqual(URL(fileURLWithExpandingTildeInPath: "/hello/world"),
                       URL(fileURLWithPath: "/hello/world"))
        
        XCTAssertEqual(URL(fileURLWithExpandingTildeInPath: "./hello/world"),
                       URL(fileURLWithPath: "./hello/world"))
        
        XCTAssertEqual(URL(fileURLWithExpandingTildeInPath: "../hello/world"),
                       URL(fileURLWithPath: "../hello/world"))
    }
}
