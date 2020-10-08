import XCTest
@testable import StaticKeyListGen

final class ActualKeyListCodeGeneratorTests: XCTestCase {
    func test_generate() {
        // Given
        let keyList = KeyList(filename: "StringKey.swift", typeName: "StringKey", keys: [
            "accept",
            "cancel",
            "loadDraft",
            "editing_menu_addBGM",
            "editing_menu_addSticker",
        ])
        
        let expectedList = """
        extension StringKey {
            static let allGeneratedKeys: [StringKey] = [
                // MARK: StringKey.swift
                .accept,
                .cancel,
                .loadDraft,
                .editing_menu_addBGM,
                .editing_menu_addSticker,
            ]
        }
        """
        
        let sut = ActualKeyListCodeGenerator()
        
        // When
        let actualList = sut.generate(from: keyList, listName: "allGeneratedKeys")
        
        // Then
        XCTAssertEqual(actualList, expectedList)
    }
}
