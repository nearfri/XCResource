import Testing
@testable import LocStringResourceGen

@Suite struct StringCatalogDTOMapperTests {
    private let sut: StringCatalogDTOMapper = .init()
    
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
    
    @Test func localizationItems_escaping() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["alert_delete_file": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "translated",
                        value: "\"%@\" will be deleted."))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "alert_delete_file",
                defaultValue: "\\\"\\(param1)\\\" will be deleted.",
                rawDefaultValue: "\\\"%@\\\" will be deleted.",
                memberDeclaration: .method("alertDeleteFile", [
                    .init(firstName: "_", secondName: "param1", type: "String")
                ]))
        ])
    }
}
