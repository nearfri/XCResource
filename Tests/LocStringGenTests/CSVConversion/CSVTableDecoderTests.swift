import XCTest
@testable import LocStringGen

final class CSVTableDecoderTests: XCTestCase {
    func test_decode() throws {
        // Given
        let csvString = """
        Key,Comment,ko,en
        cancel,취소,취소,Cancel
        confirm,확인,확인,Confirm
        
        """
        
        let expectedTable = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
                ["confirm", "확인", "확인", "Confirm"]
            ])
        
        // When
        let actualTable = try CSVTableDecoder().decode(from: csvString)
        
        // Then
        XCTAssertEqual(actualTable, expectedTable)
    }
}
