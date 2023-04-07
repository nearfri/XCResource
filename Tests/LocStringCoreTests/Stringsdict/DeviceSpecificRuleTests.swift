import XCTest
@testable import LocStringCore

final class DeviceSpecificRuleTests: XCTestCase {
    func test_initWithPlist() throws {
        // Given
        let plistString = """
            <dict>
                <key>NSStringDeviceSpecificRuleType</key>
                <dict>
                    <key>iphone</key>
                    <string>Tap here</string>
                    <key>mac</key>
                    <string>Click here</string>
                    <key>appletv</key>
                    <string>Press here</string>
                </dict>
            </dict>
            """
        let xml = try XMLElement(xmlString: plistString)
        let plist = try Plist(xmlElement: xml)
        let info = try XCTUnwrap(plist.dictionaryValue)
        
        // When
        let rule = try DeviceSpecificRule(key: "UserInstructions", info: info)
        
        // Then
        XCTAssertEqual(rule, DeviceSpecificRule(key:  "UserInstructions", stringsByDevice: [
            "iphone": "Tap here",
            "mac": "Click here",
            "appletv": "Press here",
        ]))
    }
}
