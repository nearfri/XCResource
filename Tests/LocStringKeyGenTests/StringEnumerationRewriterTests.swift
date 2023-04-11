import XCTest
import LocStringCore
import TestUtil
import SwiftSyntax
import SwiftSyntaxParser
@testable import LocStringKeyGen

private enum Fixture {
    static let sourceCode: String = """
    enum StringKey: String, CaseIterable {
        // MARK: - Common
        
        /// Cancel
        case cancel = "common_cancel"
        
        /// Confirm
        case confirm = "common_confirm"
    }
    """
}

final class StringEnumerationRewriterTests: XCTestCase {
    private var fileNode: SourceFileSyntax!
    
    override func setUpWithError() throws {
        fileNode = try SyntaxParser.parse(source: Fixture.sourceCode)
    }
    
    // MARK: - insert
    
    func test_insertAtStart() throws {
        // Given
        let localizationItem = LocalizationItem(
            id: "hello",
            key: "greeting_hello",
            value: "",
            comment: "Hello")
        
        let diff = LocalizationDifference(insertions: [(index: 0, item: localizationItem)])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in nil })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                /// Hello
                case hello = "greeting_hello"
                
                // MARK: - Common
                
                /// Cancel
                case cancel = "common_cancel"
                
                /// Confirm
                case confirm = "common_confirm"
            }
            """)
    }
    
    func test_insertAtMiddle() throws {
        // Given
        let localizationItem = LocalizationItem(
            id: "hello",
            key: "greeting_hello",
            value: "",
            comment: "Hello")
        
        let diff = LocalizationDifference(insertions: [(index: 1, item: localizationItem)])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in nil })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                // MARK: - Common
                
                /// Cancel
                case cancel = "common_cancel"
                
                /// Hello
                case hello = "greeting_hello"
                
                /// Confirm
                case confirm = "common_confirm"
            }
            """)
    }
    
    func test_insertWithAdditionalLineComment() throws {
        // Given
        let localizationItem = LocalizationItem(
            id: "hello",
            key: "greeting_hello",
            value: "",
            comment: "Hello")
        
        let diff = LocalizationDifference(insertions: [(index: 0, item: localizationItem)])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in "xcresource:target:stringsdict" })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                // xcresource:target:stringsdict
                /// Hello
                case hello = "greeting_hello"
                
                // MARK: - Common
                
                /// Cancel
                case cancel = "common_cancel"
                
                /// Confirm
                case confirm = "common_confirm"
            }
            """)
    }
    
    // MARK: - remove
    
    func test_removeMiddleCase() throws {
        // Given
        let diff = LocalizationDifference(removals: ["confirm"])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in nil })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                // MARK: - Common
                
                /// Cancel
                case cancel = "common_cancel"
            }
            """)
    }
    
    func test_removeStartCase() throws {
        // Given
        let diff = LocalizationDifference(removals: ["cancel"])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in nil })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                /// Confirm
                case confirm = "common_confirm"
            }
            """)
    }
    
    // MARK: - modify
    
    func test_modify_replaceComment() throws {
        // Given
        let diff = LocalizationDifference(modifications: [
            "cancel": LocalizationItem(
                id: "cancel",
                key: "common_cancel",
                value: "",
                comment: "Cancel Text")
        ])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in nil })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                // MARK: - Common
                
                /// Cancel Text
                case cancel = "common_cancel"
                
                /// Confirm
                case confirm = "common_confirm"
            }
            """)
    }
    
    func test_modify_removeComment() throws {
        // Given
        let diff = LocalizationDifference(modifications: [
            "cancel": LocalizationItem(
                id: "cancel",
                key: "common_cancel",
                value: "",
                comment: nil)
        ])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in nil })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                // MARK: - Common
                
                case cancel = "common_cancel"
                
                /// Confirm
                case confirm = "common_confirm"
            }
            """)
    }
    
    func test_modifyWithAdditionalLineComment() throws {
        // Given
        let diff = LocalizationDifference(modifications: [
            "cancel": LocalizationItem(
                id: "cancel",
                key: "common_cancel",
                value: "",
                comment: "Cancel Text")
        ])
        let sut = StringEnumerationRewriter(
            difference: diff,
            lineCommentForLocalizationItem: { _ in "xcresource:target:stringsdict" })
        
        // When
        let modifiedNode = sut.visit(fileNode)
        
        // Then
        XCTAssertEqual(modifiedNode.description, """
            enum StringKey: String, CaseIterable {
                // MARK: - Common
                
                // xcresource:target:stringsdict
                /// Cancel Text
                case cancel = "common_cancel"
                
                /// Confirm
                case confirm = "common_confirm"
            }
            """)
    }
}
