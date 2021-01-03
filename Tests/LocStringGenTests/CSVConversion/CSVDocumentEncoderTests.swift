import XCTest
@testable import LocStringGen

final class CSVDocumentEncoderTests: XCTestCase {
    func test_encode() throws {
        // Given
        let document = LocalizationDocument(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
                ["confirm", "확인", "확인", "Confirm"]
            ])
        
        let expectedCSVString = """
        Key,Comment,ko,en
        cancel,취소,취소,Cancel
        confirm,확인,확인,Confirm
        
        """
        
        // When
        let actualCSVString = try CSVDocumentEncoder().encode(document)
        
        // Then
        XCTAssertEqual(actualCSVString, expectedCSVString)
    }
}
