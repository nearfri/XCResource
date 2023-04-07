import XCTest
import TestUtil
import SampleData
@testable import XCResourceCommand

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

final class StringsdictToSwiftTests: XCTestCase {
    func test_runAsRoot() throws {
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
        XCTAssertEqual(try String(contentsOf: sourceCodeURL), Fixture.newSourceCode)
    }
}
