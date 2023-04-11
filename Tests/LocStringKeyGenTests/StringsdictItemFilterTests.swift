import XCTest
import LocStringCore
@testable import LocStringKeyGen

final class StringsdictItemFilterTests: XCTestCase {
    private var sut: StringsdictItemFilter!
    
    override func setUp() {
        sut = StringsdictItemFilter(commandNameForInclusion: "xcresource:target:stringsdict")
    }
    
    func test_isIncluded_pluralComment_returnsTrue() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            comment: "My dog ate %#@appleCount@ today!")
        
        // When
        let isIncluded = sut.isIncluded(item)
        
        // Then
        XCTAssertTrue(isIncluded)
    }
    
    func test_isIncluded_hasInclusionCommand_returnsTrue() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            developerComments: ["xcresource:target:stringsdict"])
        
        // When
        let isIncluded = sut.isIncluded(item)
        
        // Then
        XCTAssertTrue(isIncluded)
    }
    
    func test_isIncluded_singleComment_returnsFalse() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            comment: "hello")
        
        // When
        let isIncluded = sut.isIncluded(item)
        
        // Then
        XCTAssertFalse(isIncluded)
    }
    
    func test_isIncluded_donNotHaveInclusionCommand_returnsFalse() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            developerComments: ["xcresource:other:command"])
        
        // When
        let isIncluded = sut.isIncluded(item)
        
        // Then
        XCTAssertFalse(isIncluded)
    }
    
    func test_lineComment_pluralComment_returnsNil() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            comment: "My dog ate %#@appleCount@ today!")
        
        // When
        let lineComment = sut.lineComment(for: item)
        
        // Then
        XCTAssertNil(lineComment)
    }
    
    func test_lineComment_singleComment_returnsCommandName() throws {
        // Given: NSStringVariableWidthRuleType or NSStringDeviceSpecificRuleType
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            comment: "hello")
        
        // When
        let lineComment = sut.lineComment(for: item)
        
        // Then
        XCTAssertEqual(lineComment, "xcresource:target:stringsdict")
    }
}
