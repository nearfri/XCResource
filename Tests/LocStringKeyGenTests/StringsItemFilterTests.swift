import XCTest
import LocStringCore
@testable import LocStringKeyGen

final class StringsItemFilterTests: XCTestCase {
    private var sut: StringsItemFilter!
    
    override func setUp() {
        sut = StringsItemFilter(commandNameForExclusion: "xcresource:target:stringsdict")
    }
    
    func test_isIncluded_pluralComment_returnsFalse() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            comment: "My dog ate %#@appleCount@ today!")
        
        // When
        let isIncluded = sut.isIncluded(item)
        
        // Then
        XCTAssertFalse(isIncluded)
    }
    
    func test_isIncluded_hasExclusionCommand_returnsFalse() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            developerComments: ["xcresource:target:stringsdict"])
        
        // When
        let isIncluded = sut.isIncluded(item)
        
        // Then
        XCTAssertFalse(isIncluded)
    }
    
    func test_isIncluded_singleCommentAndDonNotHaveExclusionCommand_returnsTrue() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel",
            comment: "hello")
        
        // When
        let isIncluded = sut.isIncluded(item)
        
        // Then
        XCTAssertTrue(isIncluded)
    }
    
    func test_lineComment_returnsNil() throws {
        // Given
        let item = LocalizationItem(
            key: "cancel",
            value: "cancel")
        
        // When
        let lineComment = sut.lineComment(for: item)
        
        // Then
        XCTAssertNil(lineComment)
    }
}
