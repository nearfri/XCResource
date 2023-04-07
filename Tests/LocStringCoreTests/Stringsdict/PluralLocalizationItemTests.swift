import XCTest
import Strix
@testable import LocStringCore

final class PluralLocalizationItemTests: XCTestCase {
    func test_initWithPlist() throws {
        // Given
        let plistString = """
            <dict>
                <key>NSStringLocalizedFormatKey</key>
                <string>%@ ate %#@appleCount@ today!</string>
                <key>appleCount</key>
                <dict>
                    <key>NSStringFormatSpecTypeKey</key>
                    <string>NSStringPluralRuleType</string>
                    <key>NSStringFormatValueTypeKey</key>
                    <string>ld</string>
                    <key>zero</key>
                    <string>no apples</string>
                    <key>one</key>
                    <string>one apple</string>
                    <key>other</key>
                    <string>%ld apples</string>
                </dict>
            </dict>
            """
        let xml = try XMLElement(xmlString: plistString)
        let plist = try Plist(xmlElement: xml)
        let info = try XCTUnwrap(plist.dictionaryValue)
        let parser = Parser.pluralVariableNames
        
        // When
        let item = try PluralLocalizationItem(
            key: "dog_eating_apples",
            info: info,
            variablesUsing: parser)
        
        // Then
        XCTAssertEqual(item, PluralLocalizationItem(
            key: "dog_eating_apples",
            format: "%@ ate %#@appleCount@ today!",
            variables: [
                "appleCount": PluralLocalizationItem.Variable(
                    specType: "NSStringPluralRuleType",
                    valueType: "ld",
                    other: "%ld apples")
            ]))
    }
}
