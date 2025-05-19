import Testing
import Foundation
@testable import LocStringResourceGen

@Suite struct StringCatalogDTOTests {
    @Test func decode_stringCatalogDTO() throws {
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
        #expect(dto == expectedDTO)
    }
    
    @Test func decode_stringDTO_substitutions() throws {
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
                                "one": PluralVariationValueDTO(
                                    stringUnit: StringUnitDTO(state: "translated",
                                                              value: "one apple")),
                                "other": PluralVariationValueDTO(
                                    stringUnit: StringUnitDTO(state: "translated",
                                                              value: "%arg apples")),
                            ]))
                    ]),
            ])
        
        // When
        let dto = try JSONDecoder().decode(StringDTO.self, from: Data(json.utf8))
        
        // Then
        #expect(dto == expectedDTO)
    }
    
    @Test func decode_simple_plural() throws {
        // Given
        let json = """
            {
              "localizations" : {
                "en" : {
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
                          "value" : "%lld apples"
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
                    variations: .plural(PluralVariationsDTO(plural: [
                        "one": PluralVariationValueDTO(
                            stringUnit: StringUnitDTO(state: "translated",
                                                      value: "one apple")),
                        "other": PluralVariationValueDTO(
                            stringUnit: StringUnitDTO(state: "translated",
                                                      value: "%lld apples")),
                    ]))),
            ])
        
        // When
        let dto = try JSONDecoder().decode(StringDTO.self, from: Data(json.utf8))
        
        // Then
        #expect(dto == expectedDTO)
    }
    
    @Test func encode_variationsDTO() throws {
        // Given
        let dto = VariationsDTO.plural(PluralVariationsDTO(plural: [
            "one": PluralVariationValueDTO(
                stringUnit: StringUnitDTO(state: "translated",
                                          value: "one apple")),
            "other": PluralVariationValueDTO(
                stringUnit: StringUnitDTO(state: "translated",
                                          value: "%lld apples")),
        ]))
        
        let expectedJSON = """
        {
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
                "value" : "%lld apples"
              }
            }
          }
        }
        """
        
        // When
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(dto)
        let json = String(decoding: jsonData, as: UTF8.self)
        
        // Then
        #expect(json == expectedJSON)
    }
    
    @Test func decode_stringDTO_variations() throws {
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
                    variations: .device(DeviceVariationsDTO(device: [
                        "appletv": .stringUnit(StringUnitDTO(state: "translated",
                                                             value: "Press here")),
                        "iphone": .stringUnit(StringUnitDTO(state: "translated",
                                                            value: "Tap here")),
                        "mac": .stringUnit(StringUnitDTO(state: "translated",
                                                         value: "Click here")),
                    ]))),
            ])
        
        // When
        let dto = try JSONDecoder().decode(StringDTO.self, from: Data(json.utf8))
        
        // Then
        #expect(dto == expectedDTO)
    }
    
    @Test func decode_stringDTO_deviceAndPluralVariations() throws {
        // Given
        let json = """
            {
              "localizations" : {
                "en" : {
                  "variations" : {
                    "device" : {
                      "iphone" : {
                        "variations" : {
                          "plural" : {
                            "one" : {
                              "stringUnit" : {
                                "state" : "translated",
                                "value" : "one iPhone"
                              }
                            },
                            "other" : {
                              "stringUnit" : {
                                "state" : "translated",
                                "value" : "%lld iPhones"
                              }
                            }
                          }
                        }
                      },
                      "ipad" : {
                        "variations" : {
                          "plural" : {
                            "one" : {
                              "stringUnit" : {
                                "state" : "translated",
                                "value" : "one iPad"
                              }
                            },
                            "other" : {
                              "stringUnit" : {
                                "state" : "translated",
                                "value" : "%lld iPads"
                              }
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
                    variations: .device(DeviceVariationsDTO(device: [
                        "iphone": .variations(PluralVariationsDTO(plural: [
                            "one": PluralVariationValueDTO(
                                stringUnit: StringUnitDTO(state: "translated",
                                                          value: "one iPhone")),
                            "other": PluralVariationValueDTO(
                                stringUnit: StringUnitDTO(state: "translated",
                                                          value: "%lld iPhones")),
                        ])),
                        "ipad": .variations(PluralVariationsDTO(plural: [
                            "one": PluralVariationValueDTO(
                                stringUnit: StringUnitDTO(state: "translated",
                                                          value: "one iPad")),
                            "other": PluralVariationValueDTO(
                                stringUnit: StringUnitDTO(state: "translated",
                                                          value: "%lld iPads")),
                        ])),
                    ]))),
            ])
        
        // When
        let dto = try JSONDecoder().decode(StringDTO.self, from: Data(json.utf8))
        
        // Then
        #expect(dto == expectedDTO)
    }
    
    @Test func encode_deviceVariationValueDTO() throws {
        // Given
        let dto = DeviceVariationValueDTO.stringUnit(StringUnitDTO(state: "translated",
                                                                   value: "Tap here"))
        
        let expectedJSON = """
        {
          "stringUnit" : {
            "state" : "translated",
            "value" : "Tap here"
          }
        }
        """
        
        // When
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(dto)
        let json = String(decoding: jsonData, as: UTF8.self)
        
        // Then
        #expect(json == expectedJSON)
    }
}
