import XCTest
import LocStringCore
import XCResourceUtil
@testable import LocStringsGen

private class FakeLanguageDetector: LocStringCore.LanguageDetector {
    func detect(at url: URL) throws -> [LanguageID] {
        return ["en", "ko"]
    }
}

private class FakeSourceCodeImporter: LocalizationItemImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        return [
            .init(key: "user_instructions", value: "", comment: "Tap here"),
            .init(key: "dog_eating_apples", value: "", comment: "%@ ate %#@appleCount@ today!"),
        ]
    }
}

private class FakeStringsdictImporter: StringsdictImporter {
    var importParamsPlist: [Plist] = []
    
    func `import`(from plist: Plist) throws -> [LocalizationItem] {
        importParamsPlist.append(plist)
        return []
    }
}

private class FakeStringsdictLocalizationItemMerger: StringsdictLocalizationItemMerger {
    var itemsByMergingParamsItemsInSourceCode: [[LocalizationItem]] = []
    var itemsByMergingParamsMergeStrategy: [MergeStrategy] = []
    
    func itemsByMerging(
        itemsInSourceCode: [LocalizationItem],
        itemsInStringsdict: [LocalizationItem],
        mergeStrategy: MergeStrategy
    ) -> [LocalizationItem] {
        itemsByMergingParamsItemsInSourceCode.append(itemsInSourceCode)
        itemsByMergingParamsMergeStrategy.append(mergeStrategy)
        return itemsInSourceCode
    }
}

private enum Fixture {
    static let enPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>user_instructions</key>
            <dict>
                <key>NSStringDeviceSpecificRuleType</key>
                <dict>
                    <key>iphone</key>
                    <string>Tap here</string>
                    <key>mac</key>
                    <string>Click here</string>
                </dict>
            </dict>
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
    
    static let koPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>user_instructions</key>
            <dict>
                <key>NSStringDeviceSpecificRuleType</key>
                <dict>
                    <key>iphone</key>
                    <string>여기를 탭하세요</string>
                    <key>mac</key>
                    <string>여기를 클릭하세요</string>
                </dict>
            </dict>
            <key>dog_eating_apples</key>
            <dict>
                <key>NSStringLocalizedFormatKey</key>
                <string>%@는 오늘 사과를 %#@appleCount@ 먹었다!</string>
                <key>appleCount</key>
                <dict>
                    <key>NSStringFormatSpecTypeKey</key>
                    <string>NSStringPluralRuleType</string>
                    <key>NSStringFormatValueTypeKey</key>
                    <string>ld</string>
                    <key>zero</key>
                    <string>안</string>
                    <key>other</key>
                    <string>%ld개</string>
                </dict>
            </dict>
        </dict>
        </plist>
        """
}

final class StringKeyToStringsdictGeneratorTests: XCTestCase {
    private var sut: StringKeyToStringsdictGenerator!
    private var stringsdictImporter: FakeStringsdictImporter!
    private var localizationItemMerger: FakeStringsdictLocalizationItemMerger!
    
    private var resourcesDirURL: URL!
    
    override func setUpWithError() throws {
        stringsdictImporter = FakeStringsdictImporter()
        
        localizationItemMerger = FakeStringsdictLocalizationItemMerger()
        
        sut = StringKeyToStringsdictGenerator(
            languageDetector: DefaultLanguageDetector(detector: FakeLanguageDetector()),
            sourceCodeImporter: FakeSourceCodeImporter(),
            stringsdictImporter: stringsdictImporter,
            localizationItemMerger: localizationItemMerger,
            stringsdictMerger: DefaultStringsdictMerger())
        
        let fm = FileManager.default
        resourcesDirURL = fm.makeTemporaryItemURL()
        
        let enURL = resourcesDirURL.appendingPathComponents(
            language: "en", tableName: "Localizable", tableType: .stringsdict)
        let koURL = resourcesDirURL.appendingPathComponents(
            language: "ko", tableName: "Localizable", tableType: .stringsdict)
        
        try fm.createDirectory(at: enURL.deletingLastPathComponent(),
                               withIntermediateDirectories: true)
        try fm.createDirectory(at: koURL.deletingLastPathComponent(),
                               withIntermediateDirectories: true)
        
        try Fixture.enPlist.write(to: enURL, atomically: true, encoding: .utf8)
        try Fixture.koPlist.write(to: koURL, atomically: true, encoding: .utf8)
    }
    
    override func tearDownWithError() throws {
        let fm = FileManager.default
        
        try fm.removeItem(at: resourcesDirURL)
    }
    
    func test_generate_allLanguages() throws {
        // Given
        let request = StringKeyToStringsdictGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: resourcesDirURL,
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment)),
                .all: .init(mergeStrategy: .doNotAdd)
            ],
            sortOrder: .key)
        
        // When
        _ = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(stringsdictImporter.importParamsPlist.count, 2)
        
        let mergeStrategies = localizationItemMerger.itemsByMergingParamsMergeStrategy
        XCTAssert(mergeStrategies.contains(.add(.comment)))
        XCTAssert(mergeStrategies.contains(.doNotAdd))
    }
    
    func test_generate_oneLanguage() throws {
        // Given
        let request = StringKeyToStringsdictGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: resourcesDirURL,
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment)),
            ],
            sortOrder: .key)
        
        // When
        _ = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(stringsdictImporter.importParamsPlist.count, 1)
        
        let mergeStrategies = localizationItemMerger.itemsByMergingParamsMergeStrategy
        XCTAssert(mergeStrategies.contains(.add(.comment)))
    }
    
    func test_generate_sort_occurrence() throws {
        // Given
        let request = StringKeyToStringsdictGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: resourcesDirURL,
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment)),
            ],
            sortOrder: .occurrence)
        
        // When
        _ = try sut.generate(for: request)
        
        // Then
        let itemsInSourceCode = localizationItemMerger.itemsByMergingParamsItemsInSourceCode[0]
        XCTAssertEqual(itemsInSourceCode.first?.key, "user_instructions")
    }
    
    func test_generate_sort_key() throws {
        // Given
        let request = StringKeyToStringsdictGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: resourcesDirURL,
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment)),
            ],
            sortOrder: .key)
        
        // When
        _ = try sut.generate(for: request)
        
        // Then
        let itemsInSourceCode = localizationItemMerger.itemsByMergingParamsItemsInSourceCode[0]
        XCTAssertEqual(itemsInSourceCode.first?.key, "dog_eating_apples")
    }
}
