import XCTest
@testable import LocStringGen

private class StubLanguageDetector: LanguageDetector {
    func detect(at url: URL) throws -> [LanguageID] {
        return ["en", "ko"]
    }
}

private class StubSourceImporter: LocalizationItemImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        return [
            .init(key: "confirm", value: "", comment: "확인 주석"),
            .init(key: "cancel", value: "", comment: "취소 주석"),
        ]
    }
}

private class StubTargetImporter: LocalizationItemImporter {
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

private class StubPropertyListGenerator: PropertyListGenerator {
    var generateParamItemsList: [[LocalizationItem]] = []
    
    func generate(from items: [LocalizationItem]) -> String {
        generateParamItemsList.append(items)
        
        return ""
    }
}

final class LocalizableStringsGeneratorTests: XCTestCase {
    func test_generate_allLanguages() throws {
        // Given
        let targetImporter = StubTargetImporter()
        let plistGenerator = StubPropertyListGenerator()
        
        let sut = LocalizableStringsGenerator(
            languageDetector: StubLanguageDetector(),
            sourceImporter: StubSourceImporter(),
            targetImporter: targetImporter,
            plistGenerator: plistGenerator)
        
        let request = LocalizableStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment), verifiesComment: true),
                .all: .init(mergeStrategy: .doNotAdd, verifiesComment: true)
            ],
            sortOrder: .key)
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNotNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(targetImporter.importParamURLs, [
            URL(fileURLWithPath: "Resources/en.lproj/Localizable.strings"),
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[0], [
            .init(key: "cancel", value: "Cancel", comment: "취소 주석"),
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[1], [
            .init(key: "cancel", value: "취소", comment: "취소 주석"),
            .init(key: "confirm", value: "확인 주석", comment: "확인 주석"),
        ])
    }
    
    func test_generate_oneLanguage() throws {
        // Given
        let targetImporter = StubTargetImporter()
        let plistGenerator = StubPropertyListGenerator()
        
        let sut = LocalizableStringsGenerator(
            languageDetector: StubLanguageDetector(),
            sourceImporter: StubSourceImporter(),
            targetImporter: targetImporter,
            plistGenerator: plistGenerator)
        
        let request = LocalizableStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            configurationsByLanguage: [
                "ko": .init(mergeStrategy: .add(.comment), verifiesComment: true),
            ],
            sortOrder: .key)
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(targetImporter.importParamURLs, [
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[0], [
            .init(key: "cancel", value: "취소", comment: "취소 주석"),
            .init(key: "confirm", value: "확인 주석", comment: "확인 주석"),
        ])
    }
    
    func test_generate_excludePlurals() throws {
        // Given
        class PluralStubSourceImporter: LocalizationItemImporter {
            func `import`(at url: URL) throws -> [LocalizationItem] {
                return [
                    .init(key: "greeting", value: "", comment: "Hello World"),
                    .init(key: "dogEatingApples",
                          value: "",
                          comment: "My dog ate %#@appleCount@ today!"),
                ]
            }
        }
        
        let targetImporter = StubTargetImporter()
        let plistGenerator = StubPropertyListGenerator()
        
        let sut = LocalizableStringsGenerator(
            languageDetector: StubLanguageDetector(),
            sourceImporter: PluralStubSourceImporter(),
            targetImporter: targetImporter,
            plistGenerator: plistGenerator)
        
        let request = LocalizableStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            configurationsByLanguage: [
                "en": .init(mergeStrategy: .add(.comment), verifiesComment: true),
            ],
            sortOrder: .key)
        
        // When
        _ = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(plistGenerator.generateParamItemsList[0], [
            .init(key: "greeting", value: "Hello World", comment:"Hello World"),
        ])
    }
}
