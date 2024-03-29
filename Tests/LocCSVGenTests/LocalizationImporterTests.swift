import XCTest
import LocStringCore
@testable import LocCSVGen

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

private class StubStringsGenerator: StringsGenerator {
    var generateParamItemsList: [[LocalizationItem]] = []
    
    func generate(from items: [LocalizationItem]) -> String {
        generateParamItemsList.append(items)
        
        return ""
    }
}

final class LocalizationImporterTests: XCTestCase {
    func test_generate() throws {
        let tableDecoder = StubTableDecoder()
        let stringsGenerator = StubStringsGenerator()
        let tableString = "Stub-Table-String"
        
        // Given
        let sut = LocalizationImporter(
            tableDecoder: tableDecoder,
            languageFormatter: StubLanguageFormatter(),
            stringsGenerator: stringsGenerator)
        
        let request = LocalizationImporter.Request(tableSource: .text(tableString))
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNotNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(tableDecoder.decodeParamString, tableString)
        
        XCTAssertEqual(stringsGenerator.generateParamItemsList[0], [
            .init(key: "cancel", value: "취소", comment: "취소")
        ])
        
        XCTAssertEqual(stringsGenerator.generateParamItemsList[1], [
            .init(key: "cancel", value: "Cancel", comment: "취소")
        ])
    }
}
