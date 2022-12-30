import XCTest
import LocStringCore
@testable import LocCSVGen

private class StubLanguageDetector: LanguageDetector {
    func detect(at url: URL) throws -> [LanguageID] {
        return ["en", "ko"]
    }
}

private class StubItemImporter: LocalizationItemImporter {
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

private class StubLanguageFormatter: LanguageFormatter {
    var style: LanguageFormatterStyle = .short
    
    func string(from language: LanguageID) -> String {
        return language.rawValue
    }
    
    func language(from string: String) -> LanguageID? {
        return LanguageID(string)
    }
}

private class StubTableEncoder: LocalizationTableEncoder {
    static let encodedTable: String = "Stub-Table"
    
    var encodeParamTable: LocalizationTable!
    
    func encode(_ table: LocalizationTable) throws -> String {
        encodeParamTable = table
        
        return Self.encodedTable
    }
}

final class LocalizationExporterTests: XCTestCase {
    func test_generate() throws {
        // Given
        let itemImporter = StubItemImporter()
        let tableEncoder = StubTableEncoder()
        
        let sut = LocalizationExporter(
            languageDetector: StubLanguageDetector(),
            itemImporter: itemImporter,
            languageFormatter: StubLanguageFormatter(),
            tableEncoder: tableEncoder)
        
        let request = LocalizationExporter.Request(
            resourcesURL: URL(fileURLWithPath: "Resources"))
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(result, StubTableEncoder.encodedTable)
        
        XCTAssertEqual(itemImporter.importParamURLs, [
            URL(fileURLWithPath: "Resources/en.lproj/Localizable.strings"),
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssert(tableEncoder.encodeParamTable.header.contains("en"))
        XCTAssert(tableEncoder.encodeParamTable.header.contains("ko"))
        XCTAssert(tableEncoder.encodeParamTable.records[0].contains("Cancel"))
        XCTAssert(tableEncoder.encodeParamTable.records[0].contains("취소"))
    }
}
