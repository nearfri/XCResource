import XCTest
@testable import LocStringCore

final class VariableWidthRuleTests: XCTestCase {
    func test_initWithPlist() throws {
        // Given
        let plistString = """
            <dict>
                <key>NSStringVariableWidthRuleType</key>
                <dict>
                    <key>1</key>
                    <string>Hi</string>
                    <key>22</key>
                    <string>Hello</string>
                    <key>53</key>
                    <string>Greetings and Salutations</string>
                </dict>
            </dict>
            """
        let xml = try XMLElement(xmlString: plistString)
        let plist = try Plist(xmlElement: xml)
        let info = try XCTUnwrap(plist.dictionaryValue)
        
        // When
        let rule = try VariableWidthRule(key: "hello", info: info)
        
        // Then
        XCTAssertEqual(rule, VariableWidthRule(key:  "hello", stringsByWidth: [
            "1": "Hi",
            "22": "Hello",
            "53": "Greetings and Salutations",
        ]))
    }
}
