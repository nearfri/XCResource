import XCTest
@testable import XCResourceCommand
import SampleData

private enum Seed {
    static let publicStringForm = """
    // This file was generated by xcresource
    // Do Not Edit Directly!

    public struct StringForm {
        public var key: String
        public var arguments: [CVarArg]
        
        public init(key: String, arguments: [CVarArg]) {
            self.key = key
            self.arguments = arguments
        }
    }

    // MARK: - StringForm generated from StringKey

    public extension StringForm {
        /// 동영상 첨부는 최대 %ld분, %@까지 가능합니다.\\n다른 파일을 선택해주세요.
        static func alert_attachTooLargeVideo(_ param1: Int, _ param2: String) -> StringForm {
            return StringForm(
                key: StringKey.alert_attachTooLargeVideo.rawValue,
                arguments: [param1, param2])
        }
        
        /// %{changeCount}ld changes made
        static func changeDescription(changeCount: Int) -> StringForm {
            return StringForm(key: StringKey.changeDescription.rawValue, arguments: [changeCount])
        }
        
        /// My dog ate %#@appleCount@ today!
        static func dogEatingApples(appleCount: Int) -> StringForm {
            return StringForm(key: StringKey.dogEatingApples.rawValue, arguments: [appleCount])
        }
    }
    
    """
}

final class KeyToFormTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let formFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: formFileURL)
        }
        
        // When
        try KeyToForm.runAsRoot(arguments: [
            "--key-file-path", SampleData.sourceCodeURL("StringKey.swift").path,
            "--form-file-path", formFileURL.path,
            "--form-type-name", "StringForm",
        ])
        
        // Then
        XCTAssertEqual(
            try String(contentsOf: formFileURL),
            try String(contentsOf: SampleData.sourceCodeURL("StringForm.swift"))
        )
    }
    
    func test_runAsRoot_publicAccessLevel() throws {
        // Given
        let fm = FileManager.default
        
        let formFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? fm.removeItem(at: formFileURL)
        }
        
        // When
        try KeyToForm.runAsRoot(arguments: [
            "--key-file-path", SampleData.sourceCodeURL("StringKey.swift").path,
            "--form-file-path", formFileURL.path,
            "--form-type-name", "StringForm",
            "--access-level", "public",
        ])
        
        // Then
        XCTAssertEqual(try String(contentsOf: formFileURL), Seed.publicStringForm)
    }
}
