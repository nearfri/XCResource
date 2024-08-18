import XCTest
import XCResourceUtil

private struct Person: SettableByKeyPath {
    var name: String
    
    var friend: Friend = .init()
}

private class Friend {
    var name: String = ""
}

final class SettableByKeyPathTests: XCTestCase {
    func test_setting_writableKeyPath() {
        let person = Person(name: "Larry Wachowski")
        
        let renamedPerson = person.with(\.name, "Lana Wachowski")
        
        XCTAssertEqual(renamedPerson.name, "Lana Wachowski")
    }
    
    func test_setting_referenceWritableKeyPath() {
        let person = Person(name: "John")
        
        let renamedPerson = person.with(\.friend.name, "Charles")
        
        XCTAssertEqual(renamedPerson.friend.name, "Charles")
    }
}
