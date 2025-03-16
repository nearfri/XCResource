import Testing
@testable import LocStringResourceGen

@Suite struct LocalizationItemTests {
    private typealias Comment = Testing.Comment
    
    @Test func documentComments() throws {
        func test(defaultValue: String,
                  expectedComments: [String],
                  _ comment: @autoclosure () -> Comment? = nil,
                  sourceLocation: SourceLocation = #_sourceLocation
        ) {
            let sut = LocalizationItem(key: "",
                                       defaultValue: defaultValue,
                                       rawDefaultValue: "",
                                       memberDeclaration: .property(""))
            #expect(
                sut.documentComments == expectedComments,
                comment(),
                sourceLocation: sourceLocation
            )
        }
        
        test(defaultValue: "hello", expectedComments: ["hello"])
        
        test(defaultValue: "hello\nworld", expectedComments: ["hello\\", "world"],
             "Multiline must end with backslash")
        
        test(defaultValue: #"\(appleCount) apples"#,
             expectedComments: [#"\\(appleCount) apples"#],
             "Backslash must be escaped")
    }
    
    @Test func documentComments_withTranslationComment() throws {
        let sut = LocalizationItem(key: "",
                                   defaultValue: "hello",
                                   rawDefaultValue: "",
                                   translationComment: "comment",
                                   memberDeclaration: .property(""))
        
        #expect(sut.documentComments == [
            "hello",
            "",
            "comment",
        ])
    }
    
    @Test func commentsSourceCode() throws {
        let sut = LocalizationItem(
            key: "",
            defaultValue: "localized string1.\nlocalized string2.",
            rawDefaultValue: "",
            translationComment: "hello\n\nworld",
            developerComments: ["cmt1", "cmt2"],
            memberDeclaration: .property(""))
        
        #expect(sut.commentsSourceCode == """
            // cmt1
            // cmt2
            /// localized string1.\\
            /// localized string2.
            ///
            /// hello
            ///
            /// world
            
            """)
    }
}
