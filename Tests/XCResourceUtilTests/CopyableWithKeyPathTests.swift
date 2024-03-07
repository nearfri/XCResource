import XCTest
import XCResourceUtil

private struct Person: CopyableWithKeyPath {
    var name: String
}

final class CopyableWithKeyPathTests: XCTestCase {
    func test_setting() {
        let person = Person(name: "Larry Wachowski")
        
        let renamedPerson = person.with(\.name, "Lana Wachowski")
        
        XCTAssertEqual(renamedPerson.name, "Lana Wachowski")
    }
}
