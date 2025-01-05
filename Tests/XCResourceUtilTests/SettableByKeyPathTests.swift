import Testing
import XCResourceUtil

private struct Person: SettableByKeyPath {
    var name: String
    
    var friend: Friend = .init()
}

private class Friend {
    var name: String = ""
}

@Suite struct SettableByKeyPathTests {
    @Test func setting_writableKeyPath() {
        let person = Person(name: "Larry Wachowski")
        
        let renamedPerson = person.with(\.name, "Lana Wachowski")
        
        #expect(renamedPerson.name == "Lana Wachowski")
    }
    
    @Test func setting_referenceWritableKeyPath() {
        let person = Person(name: "John")
        
        let renamedPerson = person.with(\.friend.name, "Charles")
        
        #expect(renamedPerson.friend.name == "Charles")
    }
}
