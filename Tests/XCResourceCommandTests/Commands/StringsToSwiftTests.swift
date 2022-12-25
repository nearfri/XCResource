import XCTest
import TestUtil
import SampleData
@testable import XCResourceCommand

private enum Seed {
    static let oldSourceCode = """
    import Foundation
    
    enum StringKey: String, CaseIterable {
        // MARK: - Common
        
        /// Cancel
        case cancel = "common_cancel"
        
        /// Confirm
        case confirm = "common_confirm"
    }
    
    """
    
    static let strings = """
    /* Greeting */
    "greeting" = "Hello %@";
    
    /* Cancel */
    "common_cancel" = "Cancel";
    
    /* Confirm */
    "common_confirm" = "Confirm";
    
    """
    
    static let newSourceCode = """
    import Foundation
    
    enum StringKey: String, CaseIterable {
        /// Hello %@
        case greeting
        
        // MARK: - Common
        
        /// Cancel
        case cancel = "common_cancel"
        
        /// Confirm
        case confirm = "common_confirm"
    }
    
    """
}

final class StringsToSwiftTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try fm.copyItem(at: SampleData.localizationDirectoryURL(), to: resourcesURL)
        
        try Seed.oldSourceCode.write(to: sourceCodeURL, atomically: false, encoding: .utf8)
        
        try Seed.strings.write(
            to: resourcesURL.appendingPathComponents(language: "en", tableName: "Localizable"),
            atomically: false,
            encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: resourcesURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        // When
        try StringsToSwift.runAsRoot(arguments: [
            "--resources-path", resourcesURL.path,
            "--language", "en",
            "--swift-path", sourceCodeURL.path,
        ])
        
        // Then
        XCTAssertEqual(try String(contentsOf: sourceCodeURL), Seed.newSourceCode)
    }
}
