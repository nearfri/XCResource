import XCTest
import TestUtil
@testable import LocStringKeyGen

private enum Fixture {
    static let oldSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable {
            // MARK: - Common
            
            /// Cancel
            case cancel = "common_cancel"
            
            /// Confirm
            case confirm = "common_confirm"
        }
        
        """
    
    static let strings = """
        /* Greeting */
        "greeting" = "Hello %@";
        
        /* Cancel */
        "common_cancel" = "Cancel";
        
        /* Confirm */
        "common_confirm" = "Confirm";
        
        """
    
    static let stringsAppliedSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable {
            /// Hello %@
            case greeting
            
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
        </dict>
        </plist>
        
        """
    
    static let stringsdictAppliedSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable {
            /// %@ ate %#@appleCount@ today!
            case dog_eating_apples
            
            // MARK: - Common
            
            /// Cancel
            case cancel = "common_cancel"
            
            /// Confirm
            case confirm = "common_confirm"
        }
        
        """
    
}

final class StringKeyGeneratorTests: XCTestCase {
    func test_stringsToStringKey() throws {
        // Given
        let fm = FileManager.default
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let stringsURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try Fixture.oldSourceCode.write(to: sourceCodeURL, atomically: false, encoding: .utf8)
        try Fixture.strings.write(to: stringsURL, atomically: false, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: stringsURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        let sut = StringKeyGenerator.stringsToStringKey()
        
        let request = StringKeyGenerator.Request(
            stringsFileURL: stringsURL,
            sourceCodeURL: sourceCodeURL)
        
        // When
        let generatedCode = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(generatedCode, Fixture.stringsAppliedSourceCode)
    }
    
    func test_stringsdictToSwift() throws {
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
        
        let sut = StringKeyGenerator.stringsdictToStringKey()
        
        let request = StringKeyGenerator.Request(
            stringsFileURL: stringsdictURL,
            sourceCodeURL: sourceCodeURL)
        
        // When
        let generatedCode = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(generatedCode, Fixture.stringsdictAppliedSourceCode)
    }
}