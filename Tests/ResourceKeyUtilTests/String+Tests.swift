import XCTest
@testable import ResourceKeyUtil

final class StringTests: XCTestCase {
    func test_addingBackslashEncoding() {
        XCTAssertEqual("ab\"cd".addingBackslashEncoding(), #"ab\"cd"#)
        XCTAssertEqual("ab\\cd".addingBackslashEncoding(), #"ab\cd"#)
        XCTAssertEqual("ab\\ncd".addingBackslashEncoding(), #"ab\ncd"#)
        XCTAssertEqual("ab\ncd".addingBackslashEncoding(), #"ab\ncd"#)
        XCTAssertEqual("ab\rcd".addingBackslashEncoding(), #"ab\rcd"#)
        XCTAssertEqual("ab\tcd".addingBackslashEncoding(), #"ab\tcd"#)
        XCTAssertEqual("ab\u{0008}cd".addingBackslashEncoding(), #"ab\bcd"#)
        XCTAssertEqual("ab\u{000C}cd".addingBackslashEncoding(), #"ab\fcd"#)
    }
    
    func test_appendingPathComponent() {
        XCTAssertEqual("/tmp".appendingPathComponent("scratch.tiff"), "/tmp/scratch.tiff")
        XCTAssertEqual("/tmp/".appendingPathComponent("scratch.tiff"), "/tmp/scratch.tiff")
        XCTAssertEqual("/".appendingPathComponent("scratch.tiff"), "/scratch.tiff")
        XCTAssertEqual("".appendingPathComponent("scratch.tiff"), "scratch.tiff")
        
        XCTAssertEqual("hello".appendingPathComponent("world"), "hello/world")
        
        XCTAssertEqual("hello".appendingPathComponent(""), "hello")
        XCTAssertEqual("".appendingPathComponent("world"), "world")
        
        XCTAssertEqual("hello".appendingPathComponent("/world"), "hello/world")
        XCTAssertEqual("hello/".appendingPathComponent("world"), "hello/world")
        XCTAssertEqual("hello/".appendingPathComponent("/world"), "hello/world")
    }
    
    func test_deletingLastPathComponent() {
        XCTAssertEqual("/tmp/scratch.tiff".deletingLastPathComponent, "/tmp")
        XCTAssertEqual("/tmp/lock/".deletingLastPathComponent, "/tmp")
        XCTAssertEqual("/tmp/".deletingLastPathComponent, "/")
        XCTAssertEqual("/tmp".deletingLastPathComponent, "/")
        XCTAssertEqual("/".deletingLastPathComponent, "/")
        XCTAssertEqual("".deletingLastPathComponent, "")
        XCTAssertEqual("scratch.tiff".deletingLastPathComponent, "")
    }
}
