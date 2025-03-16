import Testing
@testable import LocStringResourceGen

@Suite struct StringCatalogDTOMapperTests {
    private let sut: StringCatalogDTOMapper = .init()
    
    @Test func localizationItems_comment() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["greeting": StringDTO(
                comment: "\"Hello\" or \"Hi\"",
                localizations: [
                    "en": LocalizationDTO(
                        stringUnit: StringUnitDTO(state: "translated", value: "Hello"))
                ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "greeting",
                defaultValue: "Hello",
                rawDefaultValue: "Hello",
                translationComment: "\"Hello\" or \"Hi\"",
                memberDeclaration: .property("greeting"))
        ])
    }
    
    @Test func localizationItems_property() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["greeting": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "translated", value: "Hello"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "greeting",
                defaultValue: "Hello",
                rawDefaultValue: "Hello",
                memberDeclaration: .property("greeting"))
        ])
    }
    
    @Test func localizationItems_property_camelCase() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["common_greeting": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "translated", value: "Hello"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "common_greeting",
                defaultValue: "Hello",
                rawDefaultValue: "Hello",
                memberDeclaration: .property("commonGreeting"))
        ])
    }
    
    @Test func localizationItems_property_deviceVariations() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["tutorial1": StringDTO(localizations: [
                "en": LocalizationDTO(
                    variations: DeviceVariationsDTO(device: [
                        "iphone": VariationValueDTO(stringUnit: StringUnitDTO(state: "translated",
                                                                              value: "Tap here")),
                        "mac": VariationValueDTO(stringUnit: StringUnitDTO(state: "translated",
                                                                           value: "Click here")),
                    ]))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "tutorial1",
                defaultValue: "Tap here",
                rawDefaultValue: "Tap here",
                memberDeclaration: .property("tutorial1"))
        ])
    }
    
    @Test func localizationItems_method() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["greeting": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "translated", value: "Hello, %@"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "greeting",
                defaultValue: "Hello, \\(param1)",
                rawDefaultValue: "Hello, %@",
                memberDeclaration: .method("greeting", [
                    LocalizationItem.Parameter(firstName: "_", secondName: "param1", type: "String")
                ]))
        ])
    }
    
    @Test func localizationItems_method_camelCase() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["common_greeting": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "translated", value: "Hello, %@"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "common_greeting",
                defaultValue: "Hello, \\(param1)",
                rawDefaultValue: "Hello, %@",
                memberDeclaration: .method("commonGreeting", [
                    LocalizationItem.Parameter(firstName: "_", secondName: "param1", type: "String")
                ]))
        ])
    }
    
    @Test func localizationItems_method_sortParameters() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["profile": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "new", value: "name: %2$@, age: %1$lld"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "profile",
                defaultValue: "\\(param1) \\(param2)\nname: %2$@, age: %1$lld",
                rawDefaultValue: "name: %2$@, age: %1$lld",
                memberDeclaration: .method("profile", [
                    LocalizationItem.Parameter(firstName: "_", secondName: "param1", type: "Int"),
                    LocalizationItem.Parameter(firstName: "_", secondName: "param2", type: "String")
                ]))
        ])
    }
    
    @Test func localizationItems_method_substitutions() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["eating_apples": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "new", value: "%@ ate %#@appleCount@."),
                    substitutions: [
                        "appleCount": SubstitutionDTO(
                            argNum: 1,
                            formatSpecifier: "lld",
                            variations: PluralVariationsDTO(plural: [
                                "zero": VariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "no apples")),
                                "one": VariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "one apple")),
                                "other": VariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "%arg apples")),
                            ]))
                    ])
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "eating_apples",
                defaultValue: "\\(param1) ate \\(appleCount).",
                rawDefaultValue: "%@ ate %#@appleCount@.",
                memberDeclaration: .method("eatingApples", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                    .init(firstName: "appleCount", type: "Int")
                ]))
        ])
    }
    
    @Test func localizationItems_property_escaping() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["sample": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "translated",
                        value: "double quotes: \"; backslash: \\"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "sample",
                defaultValue: "double quotes: \\\"; backslash: \\\\",
                rawDefaultValue: "double quotes: \\\"; backslash: \\\\",
                memberDeclaration: .property("sample"))
        ])
    }
    
    @Test func localizationItems_method_escaping() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["alert_delete_file": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "translated",
                        value: "\"%@\" will be deleted. '\\' is called a backslash."))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "alert_delete_file",
                defaultValue: "\\\"\\(param1)\\\" will be deleted. '\\\\' is called a backslash.",
                rawDefaultValue: "\\\"%@\\\" will be deleted. '\\\\' is called a backslash.",
                memberDeclaration: .method("alertDeleteFile", [
                    .init(firstName: "_", secondName: "param1", type: "String")
                ]))
        ])
    }
    
    @Test func localizationItems_property_percentSign() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["orange_juice": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "translated",
                        value: "100% orange juice"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        let item = try #require(items.first)
        #expect(item.key == "orange_juice")
        #expect(item.rawDefaultValue == "100% orange juice")
        #expect(item.memberDeclaration.id == "orangeJuice")
    }
    
    @Test func localizationItems_method_percentSign() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["juice": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "translated",
                        value: "Hello, %@. This is 100%% %@ juice."))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "juice",
                defaultValue: "Hello, \\(param1). This is 100% \\(param2) juice.",
                rawDefaultValue: "Hello, %@. This is 100%% %@ juice.",
                memberDeclaration: .method("juice", [
                    .init(firstName: "_", secondName: "param1", type: "String"),
                    .init(firstName: "_", secondName: "param2", type: "String"),
                ]))
        ])
    }
    
    @Test func localizationItems_method_percentSign_indexedParameters() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["sample": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "new",
                        value: "percent: %%, str: %2$@, int: %1$lld"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "sample",
                defaultValue: "\\(param1) \\(param2)\npercent: %%, str: %2$@, int: %1$lld",
                rawDefaultValue: "percent: %%, str: %2$@, int: %1$lld",
                memberDeclaration: .method("sample", [
                    LocalizationItem.Parameter(firstName: "_", secondName: "param1", type: "Int"),
                    LocalizationItem.Parameter(firstName: "_", secondName: "param2", type: "String")
                ]))
        ])
    }
}
