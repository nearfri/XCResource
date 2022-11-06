import XCTest
import XCResourceUtil

private struct Person: SettableByKeyPath {
    var name: String
}

final class SettableByKeyPathTests: XCTestCase {
    func test_setting() {
        let person = Person(name: "Larry Wachowski")
        
        let renamedPerson = person.setting(\.name, "Lana Wachowski")
        
        XCTAssertEqual(renamedPerson.name, "Lana Wachowski")
    }
}
