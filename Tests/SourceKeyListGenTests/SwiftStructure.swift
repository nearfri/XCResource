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
                "key.name": "StringKey",
                "key.offset": 19 as Int64,
                "key.substructure": [
                    [
                        "key.kind": "source.lang.swift.decl.var.instance",
                        "key.name": "rawValue",
                        "key.offset": 52 as Int64,
                        "key.typename": "String"
                    ]
                ]
            ]
        ]
    ]
}

final class SwiftStructureTests: XCTestCase {
    func test_initWithDictionary() throws {
        // When
        let structure = SwiftStructure(dictionary: Seed.sourceStructure)
        
        // Then
        XCTAssertEqual(structure.offset, 0)
        
        let substructureLevel1 = try XCTUnwrap(structure.substructures?.first)
        XCTAssertEqual(substructureLevel1.name, "StringKey")
        XCTAssertEqual(substructureLevel1.offset, 19)
        
        let substructureLevel2 = try XCTUnwrap(substructureLevel1.substructures?.first)
        XCTAssertEqual(substructureLevel2.typeName, "String")
    }
}
