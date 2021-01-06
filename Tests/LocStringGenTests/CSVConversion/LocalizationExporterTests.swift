import XCTest
@testable import LocStringGen

private class StubLanguageDetector: LanguageDetector {
    func detect(at url: URL) throws -> [LanguageID] {
        return ["en", "ko"]
    }
}

private class StubItemImporter: LocalizationItemImporter {
    var fetchParamURLs: [URL] = []
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
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

private class StubLanguageFormatter: LanguageFormatter {
    var style: LanguageFormatterStyle = .short
    
    func string(from language: LanguageID) -> String {
        return language.rawValue
    }
    
    func language(from string: String) -> LanguageID? {
        return LanguageID(string)
    }
}

private class StubDocumentEncoder: LocalizationDocumentEncoder {
    static let encodedDocument: String = "Stub-Document"
    
    var encodeParamDocument: LocalizationDocument!
    
    func encode(_ document: LocalizationDocument) throws -> String {
        encodeParamDocument = document
        
        return Self.encodedDocument
    }
}

final class LocalizationExporterTests: XCTestCase {
    func test_generate() throws {
        // Given
        let itemImporter = StubItemImporter()
        let documentEncoder = StubDocumentEncoder()
        
        let sut = LocalizationExporter(
            languageDetector: StubLanguageDetector(),
            itemImporter: itemImporter,
            languageFormatter: StubLanguageFormatter(),
            documentEncoder: documentEncoder)
        
        let request = LocalizationExporter.Request(
            resourcesURL: URL(fileURLWithPath: "Resources"))
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(result, StubDocumentEncoder.encodedDocument)
        
        XCTAssertEqual(itemImporter.fetchParamURLs, [
            URL(fileURLWithPath: "Resources/en.lproj/Localizable.strings"),
            URL(fileURLWithPath: "Resources/ko.lproj/Localizable.strings"),
        ])
        
        XCTAssert(documentEncoder.encodeParamDocument.header.contains("en"))
        XCTAssert(documentEncoder.encodeParamDocument.header.contains("ko"))
        XCTAssert(documentEncoder.encodeParamDocument.records[0].contains("Cancel"))
        XCTAssert(documentEncoder.encodeParamDocument.records[0].contains("취소"))
    }
}
