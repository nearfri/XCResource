import XCTest
import SwiftSyntax
@testable import LocStringGen

private enum Seed {
    static let stringKeyEnum = """
    enum StringKey: String, CaseIterable {
        /// 취소
        case common_cancel
        
        /// 완료
        case common_confirm
        
        /// 편집을 취소하시겠습니까?
        /// 확인 선택 시 모든 변경사항이 사라집니다.
        case errorPopup_cancel_editing = "errorPopup_cancelEditing"
        
        /// 영상은 최대 %d분, %fGB까지 가능합니다.\\n길이를 수정하세요.
        case errorPopup_overMaximumSize
    }
    """
}

final class StringEnumerationCollectorTests: XCTestCase {
    func test_walk() throws {
        // Given
        let sut = StringEnumerationCollector()
        let syntaxTree: SourceFileSyntax = try SyntaxParser.parse(source: Seed.stringKeyEnum)
        
        let expectedEnum = Enumeration<String>(identifier: "StringKey", cases: [
            .init(comment: "취소",
                  identifier: "common_cancel",
                  rawValue: "common_cancel"),
            .init(comment: "완료",
                  identifier: "common_confirm",
                  rawValue: "common_confirm"),
            .init(comment: "편집을 취소하시겠습니까? 확인 선택 시 모든 변경사항이 사라집니다.",
                  identifier: "errorPopup_cancel_editing",
                  rawValue: "errorPopup_cancelEditing"),
            .init(comment: "영상은 최대 %d분, %fGB까지 가능합니다.\\n길이를 수정하세요.",
                  identifier: "errorPopup_overMaximumSize",
                  rawValue: "errorPopup_overMaximumSize")
        ])
        
        // When
        sut.walk(syntaxTree)
        let actualEnum = try XCTUnwrap(sut.enumerations.first)
        
        // Then
        XCTAssertEqual(actualEnum, expectedEnum)
    }
}
