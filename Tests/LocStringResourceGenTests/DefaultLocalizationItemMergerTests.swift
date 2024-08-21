import XCTest
@testable import LocStringResourceGen

final class DefaultLocalizationItemMergerTests: XCTestCase {
    private let sut: DefaultLocalizationItemMerger = .init(
        commentCommandNames: .init(useRaw: "xcresource:use-raw"))
    
    func test_itemsByMerging_matchParameterTypes_useParametersInSourceCode() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclation: .method("hello", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
            .init(key: "bye",
                  defaultValue: "Bye \\(param1)!!",
                  rawDefaultValue: "Bye %@!!",
                  memberDeclation: .method("bye", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!!",
                  rawDefaultValue: "",
                  memberDeclation: .method("hello", [
                    .init(firstName: "name", type: "String"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        XCTAssertEqual(newItems, [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclation: .method("hello", [
                    .init(firstName: "name", type: "String"),
                  ])),
            .init(key: "bye",
                  defaultValue: "Bye \\(param1)!!",
                  rawDefaultValue: "Bye %@!!",
                  memberDeclation: .method("bye", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ])
    }
    
    func test_itemsByMerging_dontMatchParameterTypes_useParametersInCatalog() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclation: .method("hello", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(code)!!",
                  rawDefaultValue: "",
                  memberDeclation: .method("hello", [
                    .init(firstName: "code", type: "Int"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        XCTAssertEqual(newItems, [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclation: .method("hello", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ])
    }
    
    func test_itemsByMerging_matchCompatibleParameterTypes_useParametersInSourceCode() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(param1)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclation: .method("hello", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!!",
                  rawDefaultValue: "",
                  memberDeclation: .method("hello", [
                    .init(firstName: "name", type: "AttributedString"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        XCTAssertEqual(newItems, [
            .init(key: "hello",
                  defaultValue: "Hello \\(name)!!",
                  rawDefaultValue: "Hello %@!!",
                  memberDeclation: .method("hello", [
                    .init(firstName: "name", type: "AttributedString"),
                  ])),
        ])
    }
    
    func test_itemsByMerging_hasUseRawComment_useRawDefaultValue() throws {
        // Given
        let itemsInCatalog: [LocalizationItem] = [
            .init(key: "success100",
                  defaultValue: "100\\(param1)uccess",
                  rawDefaultValue: "100% success",
                  memberDeclation: .method("success100", [
                    .init(firstName: "_", secondName: "param1", type: "UnsafePointer<UInt8>"),
                  ])),
        ]
        
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "success100",
                  defaultValue: "100\\(param1)uccess",
                  rawDefaultValue: "",
                  developerComments: ["xcresource:use-raw"],
                  memberDeclation: .method("success100", [
                    .init(firstName: "_", secondName: "param1", type: "UnsafePointer<UInt8>"),
                  ])),
        ]
        
        // When
        let newItems = sut.itemsByMerging(itemsInCatalog: itemsInCatalog,
                                          itemsInSourceCode: itemsInSourceCode)
        
        // Then
        XCTAssertEqual(newItems, [
            .init(key: "success100",
                  defaultValue: "100% success",
                  rawDefaultValue: "100% success",
                  developerComments: ["xcresource:use-raw"],
                  memberDeclation: .property("success100")),
        ])
    }
}
