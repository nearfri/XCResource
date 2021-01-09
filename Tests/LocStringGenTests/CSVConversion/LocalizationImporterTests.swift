import XCTest
@testable import LocStringGen

private class StubTableDecoder: LocalizationTableDecoder {
    var decodeParamString: String!
    
    func decode(from string: String) throws -> LocalizationTable {
        decodeParamString = string
        
        return LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [["cancel", "취소", "취소", "Cancel"]])
    }
}

private class StubLanguageFormatter: LanguageFormatter {
    var style: LanguageFormatterStyle = .short
    
    func string(from language: LanguageID) -> String {
        return language.rawValue
    }
    
    func language(from string: String) -> LanguageID? {
        return LanguageID(string)
    }
}

private class StubPropertyListGenerator: PropertyListGenerator {
    var generateParamItemsList: [[LocalizationItem]] = []
    
    func generate(from items: [LocalizationItem]) -> String {
        generateParamItemsList.append(items)
        
        return ""
    }
}

final class LocalizationImporterTests: XCTestCase {
    func test_generate() throws {
        let tableDecoder = StubTableDecoder()
        let plistGenerator = StubPropertyListGenerator()
        let tableString = "Stub-Table-String"
        
        // Given
        let sut = LocalizationImporter(
            tableDecoder: tableDecoder,
            languageFormatter: StubLanguageFormatter(),
            plistGenerator: plistGenerator)
        
        let request = LocalizationImporter.Request(tableSource: .text(tableString))
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNotNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(tableDecoder.decodeParamString, tableString)
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[0], [
            .init(comment: "취소", key: "cancel", value: "취소")
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[1], [
            .init(comment: "취소", key: "cancel", value: "Cancel")
        ])
    }
}
