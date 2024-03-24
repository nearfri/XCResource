import XCTest
@testable import LocStringResourceGen

final class LocalizationItem_ParameterTests: XCTestCase {
    private typealias Parameter = LocalizationItem.Parameter
    
    func test_resolvedParameterTypes_property_returnEmpty() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "hello",
            rawDefaultValue: "",
            memberDeclation: .property("key"))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        XCTAssertEqual(parameterTypes, [])
    }
    
    func test_resolvedParameterTypes() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Name:\\(name)\nAge: \\(age)",
            rawDefaultValue: "",
            memberDeclation: .method("key", [
                Parameter(firstName: "_", secondName: "name", type: "String"),
                Parameter(firstName: "age", type: "Int"),
            ]))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        XCTAssertEqual(parameterTypes, ["String", "Int"])
    }
    
    func test_resolvedParameterTypes_keepOrderInDefaultValue() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Name:\\(name)\nAge: \\(age)",
            rawDefaultValue: "",
            memberDeclation: .method("key", [
                Parameter(firstName: "age", type: "Int"),
                Parameter(firstName: "_", secondName: "name", type: "String"),
            ]))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        XCTAssertEqual(parameterTypes, ["String", "Int"])
    }
    
    func test_resolvedParameterTypes_formatInterpolation() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Age: \\(age, format: .number)",
            rawDefaultValue: "",
            memberDeclation: .method("key", [
                Parameter(firstName: "age", type: "Int"),
            ]))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        XCTAssertEqual(parameterTypes, ["String"])
    }
    
    func test_resolvedParameterTypes_placeholderInterpolation() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Number: \\(placeholder: .double)",
            rawDefaultValue: "",
            memberDeclation: .method("key", []))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        XCTAssertEqual(parameterTypes, ["Double"])
    }
    
    func test_replaceInterpolations() throws {
        // Given
        var item = LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(param1)!!",
            rawDefaultValue: "Hello, %@",
            memberDeclation: .method("key", [
                .init(firstName: "_", secondName: "param1", type: "String")
            ]))
        
        let otherItem = LocalizationItem(
            key: "key",
            defaultValue: "Hi, \\(name).",
            rawDefaultValue: "",
            memberDeclation: .method("key", [
                .init(firstName: "name", type: "String")
            ]))
        
        // When
        try item.replaceInterpolations(with: otherItem)
        
        // Then
        XCTAssertEqual(item, LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(name)!!",
            rawDefaultValue: "Hello, %@",
            memberDeclation: .method("key", [
                .init(firstName: "_", secondName: "param1", type: "String")
            ])))
    }
    
    func test_replaceInterpolations_dontMatchInterpolationCount_throwError() throws {
        // Given
        var item = LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(param1) and \\(param2)!!",
            rawDefaultValue: "Hello, %@ and %@",
            memberDeclation: .method("key", [
                .init(firstName: "_", secondName: "param1", type: "String"),
                .init(firstName: "_", secondName: "param2", type: "String"),
            ]))
        
        let otherItem = LocalizationItem(
            key: "key",
            defaultValue: "Hi, \\(name).",
            rawDefaultValue: "",
            memberDeclation: .method("key", [
                .init(firstName: "name", type: "String")
            ]))
        
        // When, Then
        XCTAssertThrowsError(try item.replaceInterpolations(with: otherItem))
    }
    
    func test_replaceInterpolations_multiline() throws {
        // Given
        var item = LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(param1)!!\nWorld!!",
            rawDefaultValue: "Hello, %@\nWorld!!",
            memberDeclation: .method("key", [
                .init(firstName: "_", secondName: "param1", type: "String")
            ]))
        
        let otherItem = LocalizationItem(
            key: "key",
            defaultValue: "Hi, \\(name).",
            rawDefaultValue: "",
            memberDeclation: .method("key", [
                .init(firstName: "name", type: "String")
            ]))
        
        // When
        try item.replaceInterpolations(with: otherItem)
        
        // Then
        XCTAssertEqual(item, LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(name)!!\nWorld!!",
            rawDefaultValue: "Hello, %@\nWorld!!",
            memberDeclation: .method("key", [
                .init(firstName: "_", secondName: "param1", type: "String")
            ])))
    }
}
