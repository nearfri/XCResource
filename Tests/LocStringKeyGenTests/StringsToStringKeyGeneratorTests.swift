import XCTest
import TestUtil
@testable import LocStringKeyGen

private enum Fixture {
    static let oldSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable {
            /// %@ ate %#@appleCount@ today!
            case dog_eating_apples
            
            // xcresource:target:stringsdict
            /// Greetings and Salutations
            case hello
            
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
    
    static let stringsAppliedSourceCode = """
        import Foundation
        
        enum StringKey: String, CaseIterable {
            /// %@ ate %#@appleCount@ today!
            case dog_eating_apples
            
            // xcresource:target:stringsdict
            /// Greetings and Salutations
            case hello
            
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

final class StringsToStringKeyGeneratorTests: XCTestCase {
    func test_generate() throws {
        // Given
        let fm = FileManager.default
        
        let sourceCodeURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let stringsURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try Fixture.oldSourceCode.write(to: sourceCodeURL, atomically: false, encoding: .utf8)
        try Fixture.strings.write(to: stringsURL, atomically: false, encoding: .utf8)
        
        defer {
            try? fm.removeItem(at: stringsURL)
            try? fm.removeItem(at: sourceCodeURL)
        }
        
        let sut = StringsToStringKeyGenerator(
            commandNameSet: .init(exclude: "xcresource:target:stringsdict"))
        
        let request = StringsToStringKeyGenerator.Request(
            stringsFileURL: stringsURL,
            sourceCodeURL: sourceCodeURL)
        
        // When
        let generatedCode = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(generatedCode, Fixture.stringsAppliedSourceCode)
    }
}
