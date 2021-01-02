import XCTest
@testable import LocStringGen

final class CSVDocumentDecoderTests: XCTestCase {
    func test_decode() throws {
        // Given
        let csvString = """
        Key,Comment,ko,en
        cancel,취소,취소,Cancel
        confirm,확인,확인,Confirm
        
        """
        
        let expectedDocument = LocalizationDocument(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
                ["confirm", "확인", "확인", "Confirm"]
            ])
        
        // When
        let actualDocument = try CSVDocumentDecoder().decode(from: csvString)
        
        // Then
        XCTAssertEqual(actualDocument, expectedDocument)
    }
}
