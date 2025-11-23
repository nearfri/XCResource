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
                    variations: .device(DeviceVariationsDTO(device: [
                        "iphone": .stringUnit(StringUnitDTO(state: "translated",
                                                            value: "Tap here")),
                        "mac": .stringUnit(StringUnitDTO(state: "translated",
                                                         value: "Click here")),
                    ])))
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
    
    @Test func localizationItems_method_formatSpecifier() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["numbers": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "translated", value: "number1 = %1$lld, number2 = %2$10.5lf"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "numbers",
                defaultValue: "number1 = \\(param1), number2 = \\(param2, specifier: \"%10.5lf\")",
                rawDefaultValue: "number1 = %1$lld, number2 = %2$10.5lf",
                memberDeclaration: .method("numbers", [
                    LocalizationItem.Parameter(firstName: "_", secondName: "param1", type: "Int"),
                    LocalizationItem.Parameter(firstName: "_", secondName: "param2", type: "Double")
                ]))
        ])
    }
    
    @Test func localizationItems_method_namedFormatSpecifier() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["number": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(
                        state: "translated", value: "number = %1$(num)10.5lf"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "number",
                defaultValue: "number = \\(num, specifier: \"%10.5lf\")",
                rawDefaultValue: "number = %1$(num)10.5lf",
                memberDeclaration: .method("number", [
                    LocalizationItem.Parameter(firstName: "num", type: "Double")
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
    
    @Test func localizationItems_method_duplicatedParameters() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["greeting": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "new", value: "hello %1$@, %1$@"))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "greeting",
                defaultValue: "hello \\(param1), \\(param1)",
                rawDefaultValue: "hello %1$@, %1$@",
                memberDeclaration: .method("greeting", [
                    LocalizationItem.Parameter(firstName: "_", secondName: "param1", type: "String")
                ]))
        ])
    }
    
    @Test func localizationItems_method_plural() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["apples": StringDTO(localizations: [
                "en": LocalizationDTO(
                    variations: .plural(PluralVariationsDTO(plural: [
                        "zero": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "no apples")),
                        "one": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "one apple")),
                        "other": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "%lld apples")),
                    ])))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "apples",
                defaultValue: "\\(param1) apples",
                rawDefaultValue: "%lld apples",
                memberDeclaration: .method("apples", [
                    .init(firstName: "_", secondName: "param1", type: "Int"),
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
                                "zero": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "no apples")),
                                "one": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "one apple")),
                                "other": PluralVariationValueDTO(stringUnit: StringUnitDTO(
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
    
    @Test func localizationItems_method_containsOnlySubstitutions() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["search_results": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "new", value: "%#@count@"),
                    substitutions: [
                        "count": SubstitutionDTO(
                            argNum: 1,
                            formatSpecifier: "lld",
                            variations: PluralVariationsDTO(plural: [
                                "zero": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "No results")),
                                "one": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "One result")),
                                "other": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "Many results")),
                            ]))
                    ])
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        #expect(items == [
            LocalizationItem(
                key: "search_results",
                defaultValue: "\\(count)\nMany results",
                rawDefaultValue: "%#@count@",
                memberDeclaration: .method("searchResults", [
                    .init(firstName: "count", type: "Int")
                ]))
        ])
    }
    
    @Test func localizationItems_method_plural_additionalArgument() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["apples": StringDTO(localizations: [
                "en": LocalizationDTO(
                    variations: .plural(PluralVariationsDTO(plural: [
                        "zero": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "no apples")),
                        "one": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "%1$lld apple")),
                        "other": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "%2$@ apples")),
                    ])))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        try #require(items.count == 1)
        let item = items[0]
        #expect(item.key == "apples")
        #expect(item.defaultValue == "\\(param1) \\(param2)\n%2$@ apples")
        #expect(item.rawDefaultValue == "%2$@ apples")
        #expect(item.memberDeclaration == .method("apples", [
            .init(firstName: "_", secondName: "param1", type: "Int"),
            .init(firstName: "_", secondName: "param2", type: "String")
        ]))
    }
    
    @Test func localizationItems_method_substitutions_additionalArgument() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["eating_apples": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "new", value: "%1$#@arg1@"),
                    substitutions: [
                        "arg1": SubstitutionDTO(
                            argNum: 1,
                            formatSpecifier: "lld",
                            variations: PluralVariationsDTO(plural: [
                                "zero": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "no apples")),
                                "one": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "%1$lld apple")),
                                "other": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "%2$@ apples")),
                            ]))
                    ])
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        try #require(items.count == 1)
        let item = items[0]
        #expect(item.key == "eating_apples")
        #expect(item.defaultValue == "\\(arg1) \\(param2)\n%2$@ apples")
        #expect(item.rawDefaultValue == "%1$#@arg1@")
        #expect(item.memberDeclaration == .method("eatingApples", [
            .init(firstName: "arg1", type: "Int"),
            .init(firstName: "_", secondName: "param2", type: "String")
        ]))
        #expect(items == [
            LocalizationItem(
                key: "eating_apples",
                defaultValue: "\\(arg1) \\(param2)\n%2$@ apples",
                rawDefaultValue: "%1$#@arg1@",
                memberDeclaration: .method("eatingApples", [
                    .init(firstName: "arg1", type: "Int"),
                    .init(firstName: "_", secondName: "param2", type: "String")
                ]))
        ])
    }
    
    @Test func localizationItems_method_plural_additionalTwoArguments() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["apples": StringDTO(localizations: [
                "en": LocalizationDTO(
                    variations: .plural(PluralVariationsDTO(plural: [
                        "zero": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "%1$@ and no apples")),
                        "one": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "%1$@ and %2$lld apple")),
                        "other": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                            state: "new", value: "%1$@ and %3$@ apples")),
                    ])))
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        try #require(items.count == 1)
        let item = items[0]
        #expect(item.key == "apples")
        #expect(item.defaultValue == "\\(param1) \\(param2) \\(param3)\n%1$@ and %3$@ apples")
        #expect(item.rawDefaultValue == "%1$@ and %3$@ apples")
        #expect(item.memberDeclaration == .method("apples", [
            .init(firstName: "_", secondName: "param1", type: "String"),
            .init(firstName: "_", secondName: "param2", type: "Int"),
            .init(firstName: "_", secondName: "param3", type: "String")
        ]))
    }
    
    @Test func localizationItems_method_substitutions_additionalTwoArguments() throws {
        // Given
        let dto = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: ["eating_apples": StringDTO(localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "new", value: "%2$#@arg2@"),
                    substitutions: [
                        "arg2": SubstitutionDTO(
                            argNum: 2,
                            formatSpecifier: "lld",
                            variations: PluralVariationsDTO(plural: [
                                "zero": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "%1$@ and no apples")),
                                "one": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "%1$@ and %2$lld apple")),
                                "other": PluralVariationValueDTO(stringUnit: StringUnitDTO(
                                    state: "new", value: "%1$@ and %3$@ apples")),
                            ]))
                    ])
            ])])
        
        // When
        let items = try sut.localizationItems(from: dto)
        
        // Then
        try #require(items.count == 1)
        let item = items[0]
        #expect(item.key == "eating_apples")
        #expect(item.defaultValue == "\\(param1) \\(arg2) \\(param3)\n%1$@ and %3$@ apples")
        #expect(item.rawDefaultValue == "%2$#@arg2@")
        #expect(item.memberDeclaration == .method("eatingApples", [
            .init(firstName: "_", secondName: "param1", type: "String"),
            .init(firstName: "arg2", type: "Int"),
            .init(firstName: "_", secondName: "param3", type: "String"),
        ]))
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
