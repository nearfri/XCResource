import Testing
import Foundation
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Fixture {
    static let enStrings = """
    /* 취소 */
    "common_cancel" = "Cancel";
    
    /* 확인 */
    "common_confirm" = "Confirm";
    
    """
    
    static let koStrings = """
    /* 취소 */
    "common_cancel" = "취소";
    
    /* 확인 */
    "common_confirm" = "확인";
    
    /* 이미지를 불러오는 데 실패했습니다. 다른 이미지를 선택해주세요. */
    "alert_failed_to_load_image" = "이미지를 불러오는 데 실패했습니다. 다른 이미지를 선택해주세요.";
    
    /* 동영상 첨부는 최대 %ld분, %@까지 가능합니다.\\n다른 파일을 선택해주세요. */
    "alert_attachTooLargeVideo" = "동영상 첨부는 최대 %ld분, %@까지 가능합니다.\\n다른 파일을 선택해주세요.";
    
    /* 100% 성공 */
    "success100" = "100% 성공";
    
    /* %{changeCount}ld changes made */
    "changeDescription" = "%ld changes made";
    
    """
}

@Suite struct SwiftToStringsTests {
    @Test func runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: SampleData.localizationDirectoryURL(), to: resourcesURL)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
        }
        
        // When
        try SwiftToStrings.runAsRoot(arguments: [
            "--swift-path", SampleData.sourceCodeURL("StringKey.swift").path,
            "--resources-path", resourcesURL.path,
            "--language-config", "ko:comment", "jp:UNLOCALIZED-TEXT", "all:dont-add",
        ])
        
        // Then
        let enStringsURL = resourcesURL.appendingPathComponent("en.lproj/Localizable.strings")
        let koStringsURL = resourcesURL.appendingPathComponent("ko.lproj/Localizable.strings")
        
        expectEqual(try String(contentsOf: enStringsURL, encoding: .utf8), Fixture.enStrings)
        expectEqual(try String(contentsOf: koStringsURL, encoding: .utf8), Fixture.koStrings)
    }
}
