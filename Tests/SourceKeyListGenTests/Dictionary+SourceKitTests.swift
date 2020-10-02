import XCTest
import SourceKittenFramework
@testable import SourceKeyListGen

private enum Seed {
    static let sourceStructure: [String: SourceKitRepresentable] = [
        "key.length": 531 as Int64,
        "key.offset": 0 as Int64,
        "key.substructure": [
            [
                "key.kind": "source.lang.swift.decl.struct",
                "key.length": 147 as Int64,
                "key.name": "StringKey",
                "key.namelength": 9 as Int64,
                "key.nameoffset": 26 as Int64,
                "key.offset": 19 as Int64,
                "key.substructure": [
                    [
                        "key.accessibility": "source.lang.swift.accessibility.internal",
                        "key.kind": "source.lang.swift.decl.var.instance",
                        "key.length": 20 as Int64,
                        "key.name": "rawValue",
                        "key.namelength": 8 as Int64,
                        "key.nameoffset": 56 as Int64,
                        "key.offset": 52 as Int64,
                        "key.setter_accessibility": "source.lang.swift.accessibility.internal",
                        "key.typename": "String"
                    ]
                ]
            ]
        ]
    ]
}

final class DictionarySourceKitTests: XCTestCase {
    func test_filterIncludedSwiftKeys() throws {
        // Given
        let structure = Seed.sourceStructure
        
        let includedKeys: Set<SwiftKey> = [
            "key.offset", "key.substructure", "key.name"
        ]
        
        let expectedStructure: [String: SourceKitRepresentable] = [
            "key.offset": 0 as Int64,
            "key.substructure": [
                [
                    "key.name": "StringKey",
                    "key.offset": 19 as Int64,
                    "key.substructure": [
                        [
                            "key.name": "rawValue",
                            "key.offset": 52 as Int64
                        ]
                    ]
                ]
            ]
        ]
        
        // When
        let filteredStructure = structure.filter(includedSwiftKeys: includedKeys, recursively: true)
        
        // Then
        XCTAssert(filteredStructure.isEqualTo(expectedStructure))
    }
    
    func test_filterExcludedSwiftKeys() throws {
        // Given
        let structure = Seed.sourceStructure
        
        let excludedKeys: Set<SwiftKey> = [
            "key.offset", "key.length", "key.kind", "key.namelength", "key.nameoffset",
            "key.accessibility", "key.setter_accessibility"
        ]
        
        let expectedStructure: [String: SourceKitRepresentable] = [
            "key.substructure": [
                [
                    "key.name": "StringKey",
                    "key.substructure": [
                        [
                            "key.name": "rawValue",
                            "key.typename": "String"
                        ]
                    ]
                ]
            ]
        ]
        
        // When
        let filteredStructure = structure.filter(excludedSwiftKeys: excludedKeys, recursively: true)
        
        // Then
        XCTAssert(filteredStructure.isEqualTo(expectedStructure))
    }
}
