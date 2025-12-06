import Testing
@testable import LocStringResourceGen

@Suite struct LocalizationItem_ParameterTests {
    private typealias Parameter = LocalizationItem.Parameter
    
    @Test func resolvedParameterTypes_property_returnEmpty() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "hello",
            rawDefaultValue: "",
            memberDeclaration: .property("key"))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        #expect(parameterTypes == [])
    }
    
    @Test func resolvedParameterTypes() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Name:\\(name)\nAge: \\(age)",
            rawDefaultValue: "",
            memberDeclaration: .method("key", [
                Parameter(firstName: "_", secondName: "name", type: "String"),
                Parameter(firstName: "age", type: "Int"),
            ]))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        #expect(parameterTypes == ["String", "Int"])
    }
    
    @Test func resolvedParameterTypes_keepOrderInDefaultValue() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Name:\\(name)\nAge: \\(age)",
            rawDefaultValue: "",
            memberDeclaration: .method("key", [
                Parameter(firstName: "age", type: "Int"),
                Parameter(firstName: "_", secondName: "name", type: "String"),
            ]))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        #expect(parameterTypes == ["String", "Int"])
    }
    
    @Test func resolvedParameterTypes_formatInterpolation() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Age: \\(age, format: .number)",
            rawDefaultValue: "",
            memberDeclaration: .method("key", [
                Parameter(firstName: "age", type: "Int"),
            ]))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        #expect(parameterTypes == ["String"])
    }
    
    @Test func resolvedParameterTypes_placeholderInterpolation() throws {
        // Given
        let item = LocalizationItem(
            key: "key",
            defaultValue: "Number: \\(placeholder: .double)",
            rawDefaultValue: "",
            memberDeclaration: .method("key", []))
        
        // When
        let parameterTypes = item.resolvedParameterTypes
        
        // Then
        #expect(parameterTypes == ["Double"])
    }
    
    @Test func replaceInterpolations() throws {
        // Given
        var item = LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(arg1)!!",
            rawDefaultValue: "Hello, %@!!",
            memberDeclaration: .method("key", [
                .init(firstName: "_", secondName: "arg1", type: "String")
            ]))
        
        let otherItem = LocalizationItem(
            key: "key",
            defaultValue: "Hi, \\(name).",
            rawDefaultValue: "",
            memberDeclaration: .method("key", [
                .init(firstName: "name", type: "String")
            ]))
        
        // When
        try item.replaceInterpolations(with: otherItem)
        
        // Then
        #expect(item == LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(name)!!",
            rawDefaultValue: "Hello, %@!!",
            memberDeclaration: .method("key", [
                .init(firstName: "_", secondName: "arg1", type: "String")
            ])))
    }
    
    @Test func replaceInterpolations_dontMatchInterpolationCount_throwError() throws {
        // Given
        var item = LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(arg1) and \\(arg2)!!",
            rawDefaultValue: "Hello, %@ and %@!!",
            memberDeclaration: .method("key", [
                .init(firstName: "_", secondName: "arg1", type: "String"),
                .init(firstName: "_", secondName: "arg2", type: "String"),
            ]))
        
        let otherItem = LocalizationItem(
            key: "key",
            defaultValue: "Hi, \\(name).",
            rawDefaultValue: "",
            memberDeclaration: .method("key", [
                .init(firstName: "name", type: "String")
            ]))
        
        // When, Then
        #expect(throws: (any Error).self) {
            try item.replaceInterpolations(with: otherItem)
        }
    }
    
    @Test func replaceInterpolations_multiline() throws {
        // Given
        var item = LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(arg1)!!\nWorld!!",
            rawDefaultValue: "Hello, %@\nWorld!!",
            memberDeclaration: .method("key", [
                .init(firstName: "_", secondName: "arg1", type: "String")
            ]))
        
        let otherItem = LocalizationItem(
            key: "key",
            defaultValue: "Hi, \\(name).",
            rawDefaultValue: "",
            memberDeclaration: .method("key", [
                .init(firstName: "name", type: "String")
            ]))
        
        // When
        try item.replaceInterpolations(with: otherItem)
        
        // Then
        #expect(item == LocalizationItem(
            key: "key",
            defaultValue: "Hello, \\(name)!!\nWorld!!",
            rawDefaultValue: "Hello, %@\nWorld!!",
            memberDeclaration: .method("key", [
                .init(firstName: "_", secondName: "arg1", type: "String")
            ])))
    }
    
    @Test(arguments: [
        (
            "Number \\(arg1)!!", "Number %lf!!",
            "Number \\(number, specifier: \"%.6lf\")!!",
            "Number \\(number)!!"
        ),
        (
            "Number \\(arg1, specifier: \"%.3lf\")!!", "Number %.3lf!!",
            "Number \\(number)!!",
            "Number \\(number, specifier: \"%.3lf\")!!"
        ),
        (
            "Number \\(arg1, specifier: \"%.3lf\")!!", "Number %.3lf!!",
            "Number \\(number, specifier: \"%.6lf\")!!",
            "Number \\(number, specifier: \"%.3lf\")!!"
        ),
        (
            "Number \\(arg1, specifier: \"%.3lf\")!!", "Number %.3lf!!",
            "Number \\(placeholder: .double, specifier: \"%.6lf\")!!",
            "Number \\(placeholder: .double, specifier: \"%.3lf\")!!"
        ),
    ])
    func replaceInterpolations_specifier(
        value: String,
        rawValue: String,
        otherValue: String,
        resultValue: String
    ) throws {
        // Given
        var item = LocalizationItem(
            key: "key",
            defaultValue: value,
            rawDefaultValue: rawValue,
            memberDeclaration: .method("key", [
                .init(firstName: "_", secondName: "arg1", type: "Double")
            ]))
        
        let otherItem = LocalizationItem(
            key: "key",
            defaultValue: otherValue,
            rawDefaultValue: "",
            memberDeclaration: .method("key", [
                .init(firstName: "number", type: "Double")
            ]))
        
        // When
        try item.replaceInterpolations(with: otherItem)
        
        // Then
        #expect(item == LocalizationItem(
            key: "key",
            defaultValue: resultValue,
            rawDefaultValue: rawValue,
            memberDeclaration: .method("key", [
                .init(firstName: "_", secondName: "arg1", type: "Double")
            ])))
    }
}
