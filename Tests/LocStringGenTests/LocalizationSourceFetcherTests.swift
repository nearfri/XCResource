import XCTest
import SampleData
@testable import LocStringGen

final class LocalizationSourceFetcherTests: XCTestCase {
    func test_fetch() throws {
        // Given
        let sut = LocalizationSourceFetcher()
        let sourceCodeURL = SampleData.sourceCodeURL("NewStringKey.swift")
        
        let expectedItems: [LocalizationItem] = [
            .init(comment: "취소",
                  key: "common_cancel",
                  value: ""),
            .init(comment: "완료",
                  key: "common_confirm",
                  value: ""),
            .init(comment: "편집을 취소하시겠습니까? 확인 선택 시 모든 변경사항이 사라집니다.",
                  key: "errorPopup_cancelEditing",
                  value: ""),
            .init(comment: "영상은 최대 %d분, %fGB까지 가능합니다.\\n길이를 수정하세요.",
                  key: "errorPopup_overMaximumSize",
                  value: "")
        ]
        
        // When
        let actualItems = try sut.fetch(at: sourceCodeURL)
        
        // Then
        XCTAssertEqual(actualItems, expectedItems)
    }
}
