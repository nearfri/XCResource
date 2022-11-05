import XCTest
@testable import LocStringGen

final class ASCIIPlistGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let sut = ASCIIPlistGenerator()
        
        let items: [LocalizationItem] = [
            LocalizationItem(key: "cancel", value: "Cancel", comment: "취소"),
            LocalizationItem(key: "confirm", value: "Confirm", comment: "확인"),
            LocalizationItem(key: "two_lines", value: "two_lines", comment: "2라인\\n문자열"),
            LocalizationItem(key: "invalidCmt", value: "invalidCmt", comment: "잘못된*/주석"),
        ]
        
        let expectedPlist = """
        /* 취소 */
        "cancel" = "Cancel";
        
        /* 확인 */
        "confirm" = "Confirm";
        
        /* 2라인\\n문자열 */
        "two_lines" = "two_lines";
        
        /* 잘못된 주석 */
        "invalidCmt" = "invalidCmt";
        """
        
        // When
        let actualPlist = sut.generate(from: items)
        
        // Then
        XCTAssertEqual(actualPlist, expectedPlist)
    }
}
