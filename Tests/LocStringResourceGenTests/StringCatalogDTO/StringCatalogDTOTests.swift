import XCTest
@testable import LocStringResourceGen

final class StringCatalogDTOTests: XCTestCase {
    func test_decode_stringCatalogDTO() throws {
        // Given
        let json = """
            {
              "sourceLanguage" : "en",
              "strings" : {
                "cancel" : {
                  "comment" : "Cancel",
                  "extractionState" : "migrated",
                  "localizations" : {
                    "en" : {
                      "stringUnit" : {
                        "state" : "translated",
                        "value" : "Cancel"
                      }
                    },
                    "ko" : {
                      "stringUnit" : {
                        "state" : "translated",
                        "value" : "취소"
                      }
                    }
                  }
                }
              },
              "version" : "1.0"
            }
            """
        
        let expectedDTO = StringCatalogDTO(
            version: "1.0",
            sourceLanguage: "en",
            strings: [
                "cancel": StringDTO(
                    comment: "Cancel",
                    extractionState: "migrated",
                    localizations: [
                        "en": LocalizationDTO(
                            stringUnit: StringUnitDTO(state: "translated", value: "Cancel")),
                        "ko": LocalizationDTO(
                            stringUnit: StringUnitDTO(state: "translated", value: "취소")),
                    ])
            ])
        
        // When
        let dto = try JSONDecoder().decode(StringCatalogDTO.self, from: Data(json.utf8))
        
        // Then
        XCTAssertEqual(dto, expectedDTO)
    }
    
    func test_decode_stringDTO_substitutions() throws {
        // Given
        let json = """
            {
              "localizations" : {
                "en" : {
                  "stringUnit" : {
                    "state" : "translated",
                    "value" : "%@ ate %#@appleCount@ today!"
                  },
                  "substitutions" : {
                    "appleCount" : {
                      "formatSpecifier" : "lld",
                      "variations" : {
                        "plural" : {
                          "one" : {
                            "stringUnit" : {
                              "state" : "translated",
                              "value" : "one apple"
                            }
                          },
                          "other" : {
                            "stringUnit" : {
                              "state" : "translated",
                              "value" : "%arg apples"
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            """
        
        let expectedDTO = StringDTO(
            localizations: [
                "en": LocalizationDTO(
                    stringUnit: StringUnitDTO(state: "translated",
                                              value: "%@ ate %#@appleCount@ today!"),
                    substitutions: [
                        "appleCount": SubstitutionDTO(
                            formatSpecifier: "lld",
                            variations: PluralVariationsDTO(plural: [
                                "one": VariationValueDTO(
                                    stringUnit: StringUnitDTO(state: "translated",
                                                              value: "one apple")),
                                "other": VariationValueDTO(
                                    stringUnit: StringUnitDTO(state: "translated",
                                                              value: "%arg apples")),
                            ]))
                    ]),
            ])
        
        // When
        let dto = try JSONDecoder().decode(StringDTO.self, from: Data(json.utf8))
        
        // Then
        XCTAssertEqual(dto, expectedDTO)
    }
    
    func test_decode_stringDTO_variations() throws {
        // Given
        let json = """
            {
              "localizations" : {
                "en" : {
                  "variations" : {
                    "device" : {
                      "appletv" : {
                        "stringUnit" : {
                          "state" : "translated",
                          "value" : "Press here"
                        }
                      },
                      "iphone" : {
                        "stringUnit" : {
                          "state" : "translated",
                          "value" : "Tap here"
                        }
                      },
                      "mac" : {
                        "stringUnit" : {
                          "state" : "translated",
                          "value" : "Click here"
                        }
                      }
                    }
                  }
                }
              }
            }
            """
        
        let expectedDTO = StringDTO(
            localizations: [
                "en": LocalizationDTO(
                    variations: DeviceVariationsDTO(device: [
                        "appletv": VariationValueDTO(
                            stringUnit: StringUnitDTO(state: "translated",
                                                      value: "Press here")),
                        "iphone": VariationValueDTO(
                            stringUnit: StringUnitDTO(state: "translated",
                                                      value: "Tap here")),
                        "mac": VariationValueDTO(
                            stringUnit: StringUnitDTO(state: "translated",
                                                      value: "Click here")),
                    ])),
            ])
        
        // When
        let dto = try JSONDecoder().decode(StringDTO.self, from: Data(json.utf8))
        
        // Then
        XCTAssertEqual(dto, expectedDTO)
    }
}
