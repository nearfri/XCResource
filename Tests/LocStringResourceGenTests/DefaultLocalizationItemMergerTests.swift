import Testing
@testable import LocStringResourceGen

@Suite struct DefaultLocalizationItemMergerTests {
    private let sut: DefaultLocalizationItemMerger = .init(
        commentDirectives: .init(verbatim: "xcresource:verbatim"))
    
    @Test func itemsByMerging_matchParameterTypes_useParametersInSourceCode() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclaration: .method("hello", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
            .init(key: "bye",
                  defaultValue: "Bye \\(param1)!!",
                  rawDefaultValue: "Bye %@!!",
                  memberDeclaration: .method("bye", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!!",
                  rawDefaultValue: "",
                  memberDeclaration: .method("greeting", [
                    .init(firstName: "name", type: "String"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        #expect(newItems == [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclaration: .method("greeting", [
                    .init(firstName: "name", type: "String"),
                  ])),
            .init(key: "bye",
                  defaultValue: "Bye \\(param1)!!",
                  rawDefaultValue: "Bye %@!!",
                  memberDeclaration: .method("bye", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ])
    }
    
    @Test func itemsByMerging_dontMatchParameterTypes_useParametersInCatalog() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclaration: .method("hello", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(code)!!",
                  rawDefaultValue: "",
                  memberDeclaration: .method("greeting", [
                    .init(firstName: "code", type: "Int"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        #expect(newItems == [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclaration: .method("greeting", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ])
    }
    
    @Test func itemsByMerging_matchCompatibleParameterTypes_useParametersInSourceCode() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!! \\(param2) percent.",
                  rawDefaultValue: "Hello %@!! %f percent.",
                  memberDeclaration: .method("hello", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                    .init(firstName: "_", secondName: "param2", type: "Float"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!! \\(progress) percent.",
                  rawDefaultValue: "",
                  memberDeclaration: .method("greeting", [
                    .init(firstName: "name", type: "AttributedString"),
                    .init(firstName: "progress", type: "Double"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        #expect(newItems == [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!! \\(progress) percent.",
                  rawDefaultValue: "Hello %@!! %f percent.",
                  memberDeclaration: .method("greeting", [
                    .init(firstName: "name", type: "AttributedString"),
                    .init(firstName: "progress", type: "Double"),
                  ])),
        ])
    }
    
    @Test func itemsByMerging_hasVerbatimComment_useRawDefaultValue() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "success100",
                  defaultValue: "100\\(param1)uccess",
                  rawDefaultValue: "100% success",
                  memberDeclaration: .method("success100", [
                    .init(firstName: "_", secondName: "param1", type: "UnsafePointer<UInt8>"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "success100",
                  defaultValue: "100\\(param1)uccess",
                  rawDefaultValue: "",
                  developerComments: ["xcresource:verbatim"],
                  memberDeclaration: .method("successAll", [
                    .init(firstName: "_", secondName: "param1", type: "UnsafePointer<UInt8>"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        #expect(newItems == [
            .init(key: "success100",
                  defaultValue: "100% success",
                  rawDefaultValue: "100% success",
                  developerComments: ["xcresource:verbatim"],
                  memberDeclaration: .property("successAll")),
        ])
    }
}
