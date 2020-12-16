import XCTest
@testable import LocStringGen

class StubLanguageDetector: LanguageDetector {
    func detect(at url: URL) throws -> [LanguageID] {
        return ["en", "ko"]
    }
}

class StubLocalizationSourceFetcher: LocalizationItemFetcher {
    func fetch(at url: URL) throws -> [LocalizationItem] {
        return [
            .init(comment: "취소 주석", key: "cancel", value: ""),
            .init(comment: "확인 주석", key: "confirm", value: ""),
        ]
    }
}

class StubLocalizationTargetFetcher: LocalizationItemFetcher {
    var fetchParamURLs: [URL] = []
    
    func fetch(at url: URL) throws -> [LocalizationItem] {
        fetchParamURLs.append(url)
        
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

class StubPropertyListGenerator: PropertyListGenerator {
    var generateParamItemsList: [[LocalizationItem]] = []
    
    func generate(from items: [LocalizationItem]) -> String {
        generateParamItemsList.append(items)
        
        return ""
    }
}

final class LocalizedStringGeneratorTests: XCTestCase {
    func test_generate() throws {
        // Given
        let targetFetcher = StubLocalizationTargetFetcher()
        let plistGenerator = StubPropertyListGenerator()
        
        let sut = LocalizedStringGenerator(
            languageDetector: StubLanguageDetector(),
            localizationSourceFetcher: StubLocalizationSourceFetcher(),
            localizationTargetFetcher: targetFetcher,
            plistGenerator: plistGenerator)
        
        let request = LocalizedStringGenerator.CodeRequest(
            sourceCodeURL: URL(fileURLWithPath: "Sources/MyStringKey.swift"),
            resourcesURL: URL(fileURLWithPath: "Resources"),
            valueStrategiesByLanguage: ["ko": .comment])
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNotNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(targetFetcher.fetchParamURLs, [
            URL(fileURLWithPath: "Resources/en.lproj/Localizable.strings"),
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[0], [
            .init(comment: "취소 주석", key: "cancel", value: "Cancel"),
            .init(comment: "확인 주석", key: "confirm", value: "UNTRANSLATED-STRING"),
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[1], [
            .init(comment: "취소 주석", key: "cancel", value: "취소"),
            .init(comment: "확인 주석", key: "confirm", value: "확인 주석"),
        ])
    }
}
