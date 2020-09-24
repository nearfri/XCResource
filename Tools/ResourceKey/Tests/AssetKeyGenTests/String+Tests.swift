import XCTest
@testable import AssetKeyGen

final class StringTests: XCTestCase {
    func test_appendingPathComponent() throws {
        XCTAssertEqual("hello".appendingPathComponent("world"), "hello/world")
        
        XCTAssertEqual("hello".appendingPathComponent(""), "hello")
        XCTAssertEqual("".appendingPathComponent("world"), "world")
        
        XCTAssertEqual("hello".appendingPathComponent("/world"), "hello/world")
        XCTAssertEqual("hello/".appendingPathComponent("world"), "hello/world")
        XCTAssertEqual("hello/".appendingPathComponent("/world"), "hello//world")
    }
}
