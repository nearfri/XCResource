import Testing
import Foundation
import TestUtil
import SampleData
@testable import XCResourceCommand

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
        </dict>
        </plist>
        
        """
    
    static let newSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable, Sendable {
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

@Suite struct StringsdictToSwiftTests {
    @Test func runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try fm.copyItem(at: SampleData.localizationDirectoryURL(), to: resourcesURL)
        
        try Fixture.oldSourceCode.write(to: sourceCodeURL, atomically: false, encoding: .utf8)
        
        let stringsdictURL = resourcesURL.appendingPathComponents(language: "en",
                                                                  tableName: "Localizable",
                                                                  tableType: .stringsdict)
        
        try Fixture.stringsdict.write(to: stringsdictURL, atomically: false, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        // When
        try StringsdictToSwift.runAsRoot(arguments: [
            "--resources-path", resourcesURL.path,
            "--language", "en",
            "--swift-path", sourceCodeURL.path,
        ])
        
        // Then
        expectEqual(try String(contentsOf: sourceCodeURL, encoding: .utf8),
                    Fixture.newSourceCode)
    }
}
