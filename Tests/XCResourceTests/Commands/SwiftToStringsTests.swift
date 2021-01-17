import XCTest
import class Foundation.Bundle
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
    
    """
}

final class SwiftToStringsTests: XCTestCase {
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
            "swift2strings",
            "--swift-path", SampleData.sourceCodeURL("StringKey.swift").path,
            "--resources-path", resourcesURL.path,
            "--default-value-strategy", "key",
            "--value-strategy", "ko:comment",
            "--value-strategy", "jp:UNTRANSLATED-TEXT",
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(process.terminationStatus, 0)
        
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
