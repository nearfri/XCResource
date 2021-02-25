import XCTest
@testable import LocStringGen

final class StandardOutputSnifferTests: XCTestCase {
    func test_data() {
        if ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] != nil {
            return
        }
        
        let sniffer = StandardOutputSniffer()
        
        sniffer.begin()
        
        print("hello1")
        print("world1")
        
        sniffer.end()
        
        XCTAssertEqual(sniffer.stringFromData(), "hello1\nworld1\n")
        
        print("hello2")
        
        XCTAssertEqual(sniffer.stringFromData(), "hello1\nworld1\n")
        
        sniffer.begin()
        
        print("world2")
        
        sniffer.end()
        
        XCTAssertEqual(sniffer.stringFromData(), "hello1\nworld1\nworld2\n")
    }
}
