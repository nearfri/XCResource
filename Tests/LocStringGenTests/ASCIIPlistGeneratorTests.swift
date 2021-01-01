import XCTest
@testable import LocStringGen

final class ASCIIPlistGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let sut = ASCIIPlistGenerator()
        
        let items: [LocalizationItem] = [
            LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
            LocalizationItem(comment: "확인", key: "confirm", value: "Confirm"),
            LocalizationItem(comment: "2라인\\n문자열", key: "two_lines", value: "two_lines"),
        ]
        
        let expectedPlist = """
        /* 취소 */
        "cancel" = "Cancel";
        
        /* 확인 */
        "confirm" = "Confirm";
        
        /* 2라인\\n문자열 */
        "two_lines" = "two_lines";
        """
        
        // When
        let actualPlist = sut.generate(from: items)
        
        // Then
        XCTAssertEqual(actualPlist, expectedPlist)
    }
}
