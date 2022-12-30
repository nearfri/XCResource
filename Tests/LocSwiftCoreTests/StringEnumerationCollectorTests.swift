import XCTest
import SwiftSyntax
import SwiftSyntaxParser
@testable import LocSwiftCore

private enum Seed {
    static let stringKeyEnum = """
    enum StringKey: String, CaseIterable {
        // MARK: - Common
        
        /// 취소
        case common_cancel
        
        /**
         완료
         */
        case common_confirm
        
        /*
         MARK: - Alert
         */
        
        /// 편집을 취소하시겠습니까?
        /// 확인 선택 시 모든 변경사항이 사라집니다.
        case alert_cancel_editing = "alert_cancelEditing"
        
        /// 영상은 최대 %ld분, %fGB까지 가능합니다.\\n길이를 수정하세요.
        case alert_overMaximumSize
    }
    """
}

final class StringEnumerationCollectorTests: XCTestCase {
    func test_walk() throws {
        // Given
        let sut = StringEnumerationCollector()
        let syntaxTree: SourceFileSyntax = try SyntaxParser.parse(source: Seed.stringKeyEnum)
        
        let expectedEnum = Enumeration<String>(identifier: "StringKey", cases: [
            .init(comments: [.line("MARK: - Common"), .documentLine("취소")],
                  identifier: "common_cancel",
                  rawValue: "common_cancel"),
            .init(comments: [.documentBlock("완료")],
                  identifier: "common_confirm",
                  rawValue: "common_confirm"),
            .init(comments: [.block("MARK: - Alert"),
                             .documentLine("편집을 취소하시겠습니까?"),
                             .documentLine("확인 선택 시 모든 변경사항이 사라집니다.")],
                  identifier: "alert_cancel_editing",
                  rawValue: "alert_cancelEditing"),
            .init(comments: [.documentLine("영상은 최대 %ld분, %fGB까지 가능합니다.\\n길이를 수정하세요.")],
                  identifier: "alert_overMaximumSize",
                  rawValue: "alert_overMaximumSize")
        ])
        
        // When
        sut.walk(syntaxTree)
        let actualEnum = try XCTUnwrap(sut.enumerations.first)
        
        // Then
        XCTAssertEqual(actualEnum, expectedEnum)
    }
}
