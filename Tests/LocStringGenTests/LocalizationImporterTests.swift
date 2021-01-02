import XCTest
@testable import LocStringGen

private class StubDocumentDecoder: LocalizationDocumentDecoder {
    var decodeParamString: String!
    
    func decode(from string: String) throws -> LocalizationDocument {
        decodeParamString = string
        
        return LocalizationDocument(
            header: ["Key", "Comment", "ko", "en"],
            records: [["cancel", "취소", "취소", "Cancel"]])
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
        let documentDecoder = StubDocumentDecoder()
        let plistGenerator = StubPropertyListGenerator()
        let documentSource = "Stub-Document-String"
        
        // Given
        let sut = LocalizationImporter(
            documentDecoder: documentDecoder,
            plistGenerator: plistGenerator)
        
        let request = LocalizationImporter.Request(
            documentSource: documentSource)
        
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertNotNil(result["en"])
        XCTAssertNotNil(result["ko"])
        
        XCTAssertEqual(documentDecoder.decodeParamString, documentSource)
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[0], [
            .init(comment: "취소", key: "cancel", value: "취소")
        ])
        
        XCTAssertEqual(plistGenerator.generateParamItemsList[1], [
            .init(comment: "취소", key: "cancel", value: "Cancel")
        ])
    }
}
