import XCTest
@testable import LocStringGen

final class ActualPropertyListGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let sut = ActualPropertyListGenerator()
        
        let items: [LocalizationItem] = [
            LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
            LocalizationItem(comment: "확인", key: "confirm", value: "Confirm")
        ]
        
        let expectedPlist = """
        /* 취소 */
        "cancel" = "Cancel";
        
        /* 확인 */
        "confirm" = "Confirm";
        """
        
        // When
        let actualPlist = sut.generate(from: items)
        
        // Then
        XCTAssertEqual(actualPlist, expectedPlist)
    }
}
