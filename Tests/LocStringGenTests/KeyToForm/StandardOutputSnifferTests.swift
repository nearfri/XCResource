import XCTest
@testable import LocStringGen

final class StandardOutputSnifferTests: XCTestCase {
    func test_data() {
        let sniffer = StandardOutputSniffer(dropsStandardOutput: true)
        
        sniffer.start()
        
        print("hello1")
        print("world1")
        
        sniffer.stop()
        
        XCTAssertEqual(sniffer.stringFromData(), "hello1\nworld1\n")
        
        print("hello2")
        
        XCTAssertEqual(sniffer.stringFromData(), "hello1\nworld1\n")
        
        sniffer.start()
        
        print("world2")
        
        sniffer.stop()
        
        XCTAssertEqual(sniffer.stringFromData(), "hello1\nworld1\nworld2\n")
    }
}
