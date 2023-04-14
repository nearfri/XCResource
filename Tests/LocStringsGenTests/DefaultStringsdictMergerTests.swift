import XCTest
import LocStringCore
@testable import LocStringsGen

final class DefaultStringsdictMergerTests: XCTestCase {
    private let sut: DefaultStringsdictMerger = .init()
    
    func test_plistByMerging_addPluralFormat() throws {
        // Given
        let localizationItem = LocalizationItem(
            key: "dog_eating_apples",
            value: "%@ ate %#@appleCount@ and %#@carrotCount@ today!",
            comment: "%{dogName}@ ate %#@appleCount@ and %#@carrotCount@ today!")
        
        let originalPlist = Plist.dictionary([:])
        
        let expectedPlist = try Plist(xmlElementString: """
            <dict>
                <key>dog_eating_apples</key>
                <dict>
                    <key>NSStringLocalizedFormatKey</key>
                    <string>%@ ate %#@appleCount@ and %#@carrotCount@ today!</string>
                    <key>appleCount</key>
                    <dict>
                        <key>NSStringFormatSpecTypeKey</key>
                        <string>NSStringPluralRuleType</string>
                        <key>NSStringFormatValueTypeKey</key>
                        <string>ld</string>
                        <key>zero</key>
                        <string>no</string>
                        <key>one</key>
                        <string>one</string>
                        <key>other</key>
                        <string>%ld</string>
                    </dict>
                    <key>carrotCount</key>
                    <dict>
                        <key>NSStringFormatSpecTypeKey</key>
                        <string>NSStringPluralRuleType</string>
                        <key>NSStringFormatValueTypeKey</key>
                        <string>ld</string>
                        <key>zero</key>
                        <string>no</string>
                        <key>one</key>
                        <string>one</string>
                        <key>other</key>
                        <string>%ld</string>
                    </dict>
                </dict>
            </dict>
            """)
        
        // When
        let actualPlist = try sut.plistByMerging(
            localizationItems: [localizationItem],
            plist: originalPlist)
        
        // Then
        XCTAssertEqual(actualPlist, expectedPlist)
    }
    
    func test_plistByMerging_addDeviceSpecificRule() throws {
        // Given
        let localizationItem = LocalizationItem(
            key: "user_instructions",
            value: "Tap here",
            comment: "Tap here")
        
        let originalPlist = Plist.dictionary([:])
        
        let expectedPlist = try Plist(xmlElementString: """
            <dict>
                <key>user_instructions</key>
                <dict>
                    <key>NSStringDeviceSpecificRuleType</key>
                    <dict>
                        <key>iphone</key>
                        <string>Tap here</string>
                        <key>mac</key>
                        <string>Tap here</string>
                        <key>appletv</key>
                        <string>Tap here</string>
                    </dict>
                </dict>
            </dict>
            """)
        
        // When
        let actualPlist = try sut.plistByMerging(
            localizationItems: [localizationItem],
            plist: originalPlist)
        
        // Then
        XCTAssertEqual(actualPlist, expectedPlist)
    }
    
    func test_plistByMerging_duplicatedKeys_keepsOriginal() throws {
        // Given
        let localizationItem = LocalizationItem(
            key: "dog_eating_apples",
            value: "My dog ate %#@appleCount@ and %#@carrotCount@ today!",
            comment: "My dog ate %#@appleCount@ and %#@carrotCount@ today!")
        
        let originalPlist = try Plist(xmlElementString: """
            <dict>
                <key>dog_eating_apples</key>
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
                        <string>no</string>
                        <key>one</key>
                        <string>one</string>
                        <key>other</key>
                        <string>%ld</string>
                    </dict>
                </dict>
            </dict>
            """)
        
        let expectedPlist = originalPlist
        
        // When
        let actualPlist = try sut.plistByMerging(
            localizationItems: [localizationItem],
            plist: originalPlist)
        
        // Then
        XCTAssertEqual(actualPlist, expectedPlist)
    }
}
