import XCTest
import TestUtil
@testable import LocCSVGen

final class CSVTableEncoderTests: XCTestCase {
    func test_encode() throws {
        // Given
        let table = LocalizationTable(
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
        let actualCSVString = try CSVTableEncoder().encode(table)
        
        // Then
        XCTAssertEqual(actualCSVString, expectedCSVString)
    }
}
