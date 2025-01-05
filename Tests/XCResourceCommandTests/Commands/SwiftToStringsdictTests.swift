import Testing
import Foundation
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let sourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable, Sendable {
            /// %{dogName}@ ate %#@appleCount@ today!
            case dog_eating_apples
            
            // xcresource:target:stringsdict
            /// Tap here
            case user_instructions
        }
        
        """
    
    static let oldStringsdict = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        \t<key>dog_eating_apples</key>
        \t<dict>
        \t\t<key>NSStringLocalizedFormatKey</key>
        \t\t<string>%@ ate %#@appleCount@ today!</string>
        \t\t<key>appleCount</key>
        \t\t<dict>
        \t\t\t<key>NSStringFormatSpecTypeKey</key>
        \t\t\t<string>NSStringPluralRuleType</string>
        \t\t\t<key>NSStringFormatValueTypeKey</key>
        \t\t\t<string>ld</string>
        \t\t\t<key>zero</key>
        \t\t\t<string>no apples</string>
        \t\t\t<key>one</key>
        \t\t\t<string>one apple</string>
        \t\t\t<key>other</key>
        \t\t\t<string>%ld apples</string>
        \t\t</dict>
        \t</dict>
        </dict>
        </plist>
        
        """
    
    static let newStringsdict = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        \t<key>dog_eating_apples</key>
        \t<dict>
        \t\t<key>NSStringLocalizedFormatKey</key>
        \t\t<string>%@ ate %#@appleCount@ today!</string>
        \t\t<key>appleCount</key>
        \t\t<dict>
        \t\t\t<key>NSStringFormatSpecTypeKey</key>
        \t\t\t<string>NSStringPluralRuleType</string>
        \t\t\t<key>NSStringFormatValueTypeKey</key>
        \t\t\t<string>ld</string>
        \t\t\t<key>zero</key>
        \t\t\t<string>no apples</string>
        \t\t\t<key>one</key>
        \t\t\t<string>one apple</string>
        \t\t\t<key>other</key>
        \t\t\t<string>%ld apples</string>
        \t\t</dict>
        \t</dict>
        \t<key>user_instructions</key>
        \t<dict>
        \t\t<key>NSStringDeviceSpecificRuleType</key>
        \t\t<dict>
        \t\t\t<key>iphone</key>
        \t\t\t<string>Tap here</string>
        \t\t\t<key>mac</key>
        \t\t\t<string>Tap here</string>
        \t\t\t<key>appletv</key>
        \t\t\t<string>Tap here</string>
        \t\t</dict>
        \t</dict>
        </dict>
        </plist>
        
        """
}

@Suite struct SwiftToStringsdictTests {
    @Test func runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try fm.copyItem(at: SampleData.localizationDirectoryURL(), to: resourcesURL)
        
        try Fixture.sourceCode.write(to: sourceCodeURL, atomically: false, encoding: .utf8)
        
        let stringsdictURL = resourcesURL.appendingPathComponents(language: "en",
                                                                  tableName: "Localizable",
                                                                  tableType: .stringsdict)
        
        try Fixture.oldStringsdict.write(to: stringsdictURL, atomically: false, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        // When
        try SwiftToStringsdict.runAsRoot(arguments: [
            "--swift-path", sourceCodeURL.path,
            "--resources-path", resourcesURL.path,
            "--language-config", "en:comment",
        ])
        
        // Then
        expectEqual(try String(contentsOf: stringsdictURL, encoding: .utf8), Fixture.newStringsdict)
    }
}
