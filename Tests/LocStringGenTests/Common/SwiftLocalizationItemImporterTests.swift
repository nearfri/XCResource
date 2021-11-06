import XCTest
import SampleData
@testable import LocStringGen

final class SwiftLocalizationItemImporterTests: XCTestCase {
    func test_import() throws {
        // Given
        let sut = SwiftLocalizationItemImporter()
        let sourceCodeURL = SampleData.sourceCodeURL("StringKey.swift")
        
        let expectedItems: [LocalizationItem] = [
            .init(comment: "취소",
                  key: "common_cancel",
                  value: ""),
            .init(comment: "확인",
                  key: "common_confirm",
                  value: ""),
            .init(comment: "이미지를 불러오는 데 실패했습니다. 다른 이미지를 선택해주세요.",
                  key: "alert_failed_to_load_image",
                  value: ""),
            .init(comment: "동영상 첨부는 최대 %ld분, %@까지 가능합니다.\\n다른 파일을 선택해주세요.",
                  key: "alert_attachTooLargeVideo",
                  value: "")
        ]
        
        // When
        let actualItems: [LocalizationItem] = try sut.import(at: sourceCodeURL)
        
        // Then
        XCTAssertEqual(actualItems, expectedItems)
    }
}
