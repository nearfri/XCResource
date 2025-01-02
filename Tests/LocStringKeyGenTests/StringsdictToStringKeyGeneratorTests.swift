import XCTest
import TestUtil
@testable import LocStringKeyGen

private enum Fixture {
    static let oldSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable, Sendable {
            // MARK: - Common
            
            /// Cancel
            case cancel = "common_cancel"
            
            /// Confirm
            case confirm = "common_confirm"
        }
        
        """
    
    static let stringsdict = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
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
                    <string>no apples</string>
                    <key>one</key>
                    <string>one apple</string>
                    <key>other</key>
                    <string>%ld apples</string>
                </dict>
            </dict>
            <key>hello</key>
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
        </dict>
        </plist>
        
        """
    
    static let stringsdictAppliedSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable, Sendable {
            /// %@ ate %#@appleCount@ today!
            case dog_eating_apples
            
            // xcresource:target:stringsdict
            /// Greetings and Salutations
            case hello
            
            // MARK: - Common
            
            /// Cancel
            case cancel = "common_cancel"
            
            /// Confirm
            case confirm = "common_confirm"
        }
        
        """
    
}

final class StringsdictToStringKeyGeneratorTests: XCTestCase {
    func test_generate() throws {
        // Given
        let fm = FileManager.default
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let stringsdictURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try Fixture.oldSourceCode.write(to: sourceCodeURL, atomically: false, encoding: .utf8)
        try Fixture.stringsdict.write(to: stringsdictURL, atomically: false, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: stringsdictURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        let sut = StringsdictToStringKeyGenerator(
            commandNameSet: .init(include: "xcresource:target:stringsdict"))
        
        let request = StringsdictToStringKeyGenerator.Request(
            stringsdictFileURL: stringsdictURL,
            sourceCodeURL: sourceCodeURL)
        
        // When
        let generatedCode = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(generatedCode, Fixture.stringsdictAppliedSourceCode)
    }
}
