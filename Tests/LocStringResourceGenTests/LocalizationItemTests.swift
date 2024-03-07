import XCTest
@testable import LocStringResourceGen

final class LocalizationItemTests: XCTestCase {
    func test_documentComments() throws {
        func test(defaultValue: String,
                  expectedComments: [String],
                  _ message: String = "",
                  line: UInt = #line
        ) {
            let sut = LocalizationItem(key: "",
                                       defaultValue: defaultValue,
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
