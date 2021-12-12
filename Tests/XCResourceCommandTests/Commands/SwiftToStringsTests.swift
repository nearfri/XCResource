import XCTest
@testable import XCResourceCommand
import SampleData

private enum Seed {
    static let enStrings = """
    /* 취소 */
    "common_cancel" = "Cancel";
    
    /* 확인 */
    "common_confirm" = "Confirm";
    
    /* 이미지를 불러오는 데 실패했습니다. 다른 이미지를 선택해주세요. */
    "alert_failed_to_load_image" = "alert_failed_to_load_image";
    
    /* 동영상 첨부는 최대 %ld분, %@까지 가능합니다.\\n다른 파일을 선택해주세요. */
    "alert_attachTooLargeVideo" = "alert_attachTooLargeVideo";
    
    /* 100% 성공 */
    "success100" = "success100";
    
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
    
    """
}

final class SwiftToStringsTests: XCTestCase {
    func test_runAsRoot() throws {
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
            "--value-strategy", "ko:comment", "jp:UNLOCALIZED-TEXT", "*:key",
        ])
        
        // Then
        let enStringsURL = resourcesURL.appendingPathComponent("en.lproj/Localizable.strings")
        let koStringsURL = resourcesURL.appendingPathComponent("ko.lproj/Localizable.strings")
        
        XCTAssertEqual(try String(contentsOf: enStringsURL), Seed.enStrings)
        XCTAssertEqual(try String(contentsOf: koStringsURL), Seed.koStrings)
    }
}
