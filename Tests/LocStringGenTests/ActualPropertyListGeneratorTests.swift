import XCTest
@testable import LocStringGen

final class ActualPropertyListGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let sut = ActualPropertyListGenerator()
        
        let items: [LocalizationItem] = [
            LocalizationItem(comment: "취소", key: "action_cancel", value: "Cancel"),
            LocalizationItem(comment: "확인", key: "action_confirm", value: "Confirm")
        ]
        
        let expectedPlist = """
        /* 취소 */
        "action_cancel" = "Cancel";
        
        /* 확인 */
        "action_confirm" = "Confirm";
        """
        
        // When
        let actualPlist = sut.generate(from: items)
        
        // Then
        XCTAssertEqual(actualPlist, expectedPlist)
    }
}
