import XCTest
@testable import LocStringCore

final class StringsdictImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let plistString = """
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
                <key>remove_file_dialog</key>
                <dict>
                    <key>NSStringLocalizedFormatKey</key>
                    <string>%#@files@</string>
                    <key>files</key>
                    <dict>
                        <key>NSStringFormatSpecTypeKey</key>
                        <string>NSStringPluralRuleType</string>
                        <key>NSStringFormatValueTypeKey</key>
                        <string>ld</string>
                        <key>zero</key>
                        <string>No files selected</string>
                        <key>one</key>
                        <string>Remove selected file</string>
                        <key>other</key>
                        <string>Remove %ld selected files</string>
                    </dict>
                </dict>
            </dict>
            </plist>
            """
        
        let fm = FileManager.default
        
        let stringsdictURL = fm.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".stringsdict")
        try plistString.write(to: stringsdictURL, atomically: true, encoding: .utf8)
        defer { try? fm.removeItem(at: stringsdictURL) }
        
        let sut = StringsdictImporter()
        
        // When
        let items = try sut.import(at: stringsdictURL)
        
        // Then
        XCTAssertEqual(items, [
            LocalizationItem(key: "dog_eating_apples", value: "%@ ate %#@appleCount@ today!"),
            LocalizationItem(key: "remove_file_dialog", value: "%#@files@"),
        ])
    }
}
