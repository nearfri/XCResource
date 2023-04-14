import XCTest
import LocStringCore
@testable import LocStringsGen

private class FakeLanguageDetector: LocStringCore.LanguageDetector {
    func detect(at url: URL) throws -> [LanguageID] {
        return ["en", "ko"]
    }
}

private class FakeSourceCodeImporter: LocalizationItemImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        return [
            .init(key: "confirm", value: "", comment: "확인 주석"),
            .init(key: "cancel", value: "", comment: "취소 주석"),
        ]
    }
}

private class FakeStringsImporter: LocalizationItemImporter {
    var importParamURLs: [URL] = []
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
        importParamURLs.append(url)
        
        if url.path.contains("en.lproj") {
            return [
                .init(key: "cancel", value: "Cancel", comment: "취소 주석"),
            ]
        } else if url.path.contains("ko.lproj") {
            return [
                .init(key: "cancel", value: "취소", comment: "취소 주석"),
            ]
        }
        
        return []
    }
}

private class FakeStringsGenerator: StringsGenerator {
    var generateParamItemsList: [[LocalizationItem]] = []
    
    func generate(from items: [LocalizationItem]) -> String {
        generateParamItemsList.append(items)
        
        return ""
    }
}

final class StringKeyToStringsGeneratorTests: XCTestCase {
    private var sut: StringKeyToStringsGenerator!
    private var stringsImporter: FakeStringsImporter!
    private var stringsGenerator: FakeStringsGenerator!
    
    override func setUp() {
        stringsImporter = FakeStringsImporter()
        
        stringsGenerator = FakeStringsGenerator()
        
        sut = StringKeyToStringsGenerator(
            languageDetector: DefaultLanguageDetector(detector: FakeLanguageDetector()),
            sourceCodeImporter: FakeSourceCodeImporter(),
            stringsImporter: stringsImporter,
            localizationItemMerger: DefaultStringsLocalizationItemMerger(),
            stringsGenerator: stringsGenerator)
    }
    
    func test_generate_allLanguages() throws {
        // Given
        let request = StringKeyToStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment), verifiesComments: true),
                .all: .init(mergeStrategy: .doNotAdd, verifiesComments: true)
            ],
            includesComments: true,
            sortOrder: .key)
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNotNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(stringsImporter.importParamURLs, [
            URL(fileURLWithPath: "Resources/en.lproj/Localizable.strings"),
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssertEqual(stringsGenerator.generateParamItemsList[0], [
            .init(key: "cancel", value: "Cancel", comment: "취소 주석"),
        ])
        
        XCTAssertEqual(stringsGenerator.generateParamItemsList[1], [
            .init(key: "cancel", value: "취소", comment: "취소 주석"),
            .init(key: "confirm", value: "확인 주석", comment: "확인 주석"),
        ])
    }
    
    func test_generate_oneLanguage() throws {
        // Given
        let request = StringKeyToStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment), verifiesComments: true),
            ],
            includesComments: true,
            sortOrder: .key)
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(stringsImporter.importParamURLs, [
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssertEqual(stringsGenerator.generateParamItemsList[0], [
            .init(key: "cancel", value: "취소", comment: "취소 주석"),
            .init(key: "confirm", value: "확인 주석", comment: "확인 주석"),
        ])
    }
    
    func test_generate_notIncludeComments() throws {
        // Given
        let request = StringKeyToStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment), verifiesComments: true),
            ],
            includesComments: false,
            sortOrder: .key)
        
        // When
        _ = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(stringsImporter.importParamURLs, [
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssertEqual(stringsGenerator.generateParamItemsList[0], [
            .init(key: "cancel", value: "취소", comment: nil),
            .init(key: "confirm", value: "확인 주석", comment: nil),
        ])
    }
    
    func test_generate_sort() throws {
        // Given
        let request = StringKeyToStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment), verifiesComments: true),
            ],
            includesComments: true,
            sortOrder: .occurrence)
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(stringsImporter.importParamURLs, [
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssertEqual(stringsGenerator.generateParamItemsList[0], [
            .init(key: "confirm", value: "확인 주석", comment: "확인 주석"),
            .init(key: "cancel", value: "취소", comment: "취소 주석"),
        ])
    }
}
