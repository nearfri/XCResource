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
            .init(comment: "확인 주석", key: "confirm", value: ""),
            .init(comment: "취소 주석", key: "cancel", value: ""),
        ]
    }
}

private class StubTargetImporter: LocalizationItemImporter {
    var importParamURLs: [URL] = []
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
        importParamURLs.append(url)
        
        if url.path.contains("en.lproj") {
            return [
                .init(comment: "취소 주석", key: "cancel", value: "Cancel"),
            ]
        } else if url.path.contains("ko.lproj") {
            return [
                .init(comment: "취소 주석", key: "cancel", value: "취소"),
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
            valueStrategiesByLanguage: ["ko": .comment],
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
            .init(comment: "취소 주석", key: "cancel", value: "Cancel"),
            .init(comment: "확인 주석", key: "confirm", value: "UNLOCALIZED-TEXT"),
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[1], [
            .init(comment: "취소 주석", key: "cancel", value: "취소"),
            .init(comment: "확인 주석", key: "confirm", value: "확인 주석"),
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
            languages: ["ko"],
            valueStrategiesByLanguage: ["ko": .comment],
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
            .init(comment: "취소 주석", key: "cancel", value: "취소"),
            .init(comment: "확인 주석", key: "confirm", value: "확인 주석"),
        ])
    }
    
    func test_generate_excludePlurals() throws {
        // Given
        class PluralStubSourceImporter: LocalizationItemImporter {
            func `import`(at url: URL) throws -> [LocalizationItem] {
                return [
                    .init(comment: "Hello World", key: "greeting", value: ""),
                    .init(comment: "My dog ate %#@appleCount@ today!",
                          key: "dogEatingApples",
                          value: ""),
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
            valueStrategiesByLanguage: ["en": .comment],
            sortOrder: .key)
        
        // When
        _ = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(plistGenerator.generateParamItemsList[0], [
            .init(comment:"Hello World", key: "greeting", value: "Hello World"),
        ])
    }
}
