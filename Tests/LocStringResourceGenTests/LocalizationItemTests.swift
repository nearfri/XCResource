import XCTest
@testable import LocStringResourceGen

final class LocalizationItemMemberDeclationTests: XCTestCase {
    func test_fixingID_validPropertyID_returnsEqual() throws {
        // Given
        let sut = LocalizationItem.MemberDeclation.property("valid_key")
        
        // When
        let fixed = sut.fixingID()
        
        // Then
        XCTAssertEqual(fixed, sut)
    }
    
    func test_fixingID_validMethodID_returnsEqual() throws {
        // Given
        let sut = LocalizationItem.MemberDeclation.method(
            "valid_id",
            [.init(firstName: "p1", type: "Int")])
        
        // When
        let fixed = sut.fixingID()
        
        // Then
        XCTAssertEqual(fixed, sut)
    }
    
    func test_fixingID_invalidID_returnFixed() throws {
        // Given
        let sut = LocalizationItem.MemberDeclation.property("punctuation/key")
        
        // When
        let fixed = sut.fixingID()
        
        // Then
        XCTAssertEqual(fixed, .property("punctuation_key"))
    }
    
    func test_fixingID_idStartsWithNumber_returnFixed() throws {
        // Given
        let sut = LocalizationItem.MemberDeclation.property("1number_key")
        
        // When
        let fixed = sut.fixingID()
        
        // Then
        XCTAssertEqual(fixed, .property("_1number_key"))
    }
}

final class LocalizationItemTests: XCTestCase {
    func test_documentComments() throws {
        func test(defaultValue: String,
                  expectedComments: [String],
                  _ message: String = "",
                  line: UInt = #line
        ) {
            let sut = LocalizationItem(key: "",
                                       defaultValue: defaultValue,
                                       rawDefaultValue: "",
                                       memberDeclation: .property(""))
            XCTAssertEqual(sut.documentComments, expectedComments, message, line: line)
        }
        
        test(defaultValue: "hello", expectedComments: ["hello"])
        
        test(defaultValue: "hello\nworld", expectedComments: ["hello\\", "world"],
             "Multiline must end with backslash")
        
        test(defaultValue: #"\(appleCount) apples"#,
             expectedComments: [#"\\(appleCount) apples"#],
             "Backslash must be escaped")
    }
    
    func test_commentsSourceCode() throws {
        let sut = LocalizationItem(
            key: "",
            defaultValue: "localized string1.\nlocalized string2.",
            rawDefaultValue: "",
            developerComments: ["cmt1", "cmt2"],
            memberDeclation: .property(""))
        
        XCTAssertEqual(sut.commentsSourceCode, """
            // cmt1
            // cmt2
            /// localized string1.\\
            /// localized string2.
            
            """)
    }
}
