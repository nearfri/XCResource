import XCTest
import class Foundation.Bundle
import SampleData

private enum Seed {
    static let enStrings = """
    /* 취소 */
    "common_cancel" = "Cancel";
    
    /* 확인 */
    "common_confirm" = "Confirm";
    
    /* 편집을 취소하시겠습니까? 확인 선택 시 모든 변경사항이 사라집니다. */
    "errorPopup_cancelEditing" = "errorPopup_cancelEditing";
    
    /* 영상은 최대 %d분, %fGB까지 가능합니다.\\n길이를 수정하세요. */
    "errorPopup_overMaximumSize" = "errorPopup_overMaximumSize";
    
    """
    
    static let koStrings = """
    /* 취소 */
    "common_cancel" = "취소";
    
    /* 확인 */
    "common_confirm" = "확인";
    
    /* 편집을 취소하시겠습니까? 확인 선택 시 모든 변경사항이 사라집니다. */
    "errorPopup_cancelEditing" = "편집을 취소하시겠습니까? 확인 선택 시 모든 변경사항이 사라집니다.";
    
    /* 영상은 최대 %d분, %fGB까지 가능합니다.\\n길이를 수정하세요. */
    "errorPopup_overMaximumSize" = "영상은 최대 %d분, %fGB까지 가능합니다.\\n길이를 수정하세요.";
    
    """
}

final class GenerateLocalizableStringsTests: XCTestCase {
    func test_main() throws {
        let fm = FileManager.default
        
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: SampleData.localizationDirectoryURL(), to: resourcesURL)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
        }
        
        let executableURL = productsDirectory.appendingPathComponent("xcresource")
        
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = [
            "generate-localizable-strings",
            "--input-source", SampleData.sourceCodeURL("StringKey.swift").path,
            "--resources", resourcesURL.path,
            "--default-value-strategy", "key",
            "--value-strategy", "ko:comment",
            "--value-strategy", "jp:UNTRANSLATED-STRING",
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let enStringsURL = resourcesURL.appendingPathComponent("en.lproj/Localizable.strings")
        let koStringsURL = resourcesURL.appendingPathComponent("ko.lproj/Localizable.strings")
        
        XCTAssertEqual(try String(contentsOf: enStringsURL), Seed.enStrings)
        XCTAssertEqual(try String(contentsOf: koStringsURL), Seed.koStrings)
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
}
