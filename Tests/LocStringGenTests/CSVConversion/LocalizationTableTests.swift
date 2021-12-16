import XCTest
@testable import LocStringGen

private class StubLanguageFormatter: LanguageFormatter {
    var style: LanguageFormatterStyle = .short
    
    func string(from language: LanguageID) -> String {
        return language.rawValue
    }
    
    func language(from string: String) -> LanguageID? {
        return LanguageID(string)
    }
}

private enum Seed {
    static let commentedSections: [LocalizationSection] = [
        LocalizationSection(language: "ko", items: [
            LocalizationItem(comment: "취소", key: "cancel", value: "취소"),
            LocalizationItem(comment: "확인", key: "confirm", value: "확인"),
        ]),
        LocalizationSection(language: "en", items: [
            LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
            LocalizationItem(comment: "확인", key: "confirm", value: "Confirm"),
        ]),
    ]
    
    static let commentedTable: LocalizationTable = .init(
        header: ["Key", "Comment", "ko", "en"],
        records: [
            ["cancel", "취소", "취소", "Cancel"],
            ["confirm", "확인", "확인", "Confirm"]
        ])
}

final class LocalizationTableTests: XCTestCase {
    func test_validate_goodTable_noThrow() {
        let table = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
            ])
        XCTAssertNoThrow(try table.validate())
    }
    
    func test_validate_noKeyColumn_throw() {
        let table = LocalizationTable(
            header: ["Comment", "ko", "en"],
            records: [
                ["취소", "취소", "Cancel"],
            ])
        XCTAssertThrowsError(try table.validate())
    }
    
    func test_validate_inconsistentColumnCount_throw() {
        let table = LocalizationTable(
            header: ["Key", "Comment", "ko"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
            ])
        XCTAssertThrowsError(try table.validate())
    }
    
    func test_initWithSections() {
        // Given
        let languageFormatter = StubLanguageFormatter()
        
        let sections: [LocalizationSection] = [
            LocalizationSection(language: "ko", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "취소"),
                LocalizationItem(comment: "확인", key: "confirm", value: "확인"),
            ]),
            LocalizationSection(language: "en", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
            ]),
        ]
        
        let expectedTable = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
                ["confirm", "확인", "확인", ""],
            ])
        
        // When
        let actualTable = LocalizationTable(sections: sections,
                                            languageFormatter: languageFormatter)
        
        // Then
        XCTAssertEqual(actualTable, expectedTable)
    }
    
    func test_initWithSections_withEmptyTranslationEncoding() throws {
        // Given
        let languageFormatter = StubLanguageFormatter()
        
        let sections: [LocalizationSection] = [
            LocalizationSection(language: "ko", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "취소"),
                LocalizationItem(comment: "확인", key: "confirm", value: "확인"),
            ]),
            LocalizationSection(language: "en", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: ""),
            ]),
        ]
        
        let expectedTable = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "취소", "#EMPTY"],
                ["confirm", "확인", "확인", ""],
            ])
        
        // When
        let actualTable = LocalizationTable(sections: sections,
                                            languageFormatter: languageFormatter,
                                            emptyTranslationEncoding: "#EMPTY")
        
        // Then
        XCTAssertEqual(actualTable, expectedTable)
    }
    
    func test_toSections_withComment() throws {
        // Given
        let languageFormatter = StubLanguageFormatter()
        
        let table = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
            ])
        
        let expectedSections: [LocalizationSection] = [
            LocalizationSection(language: "ko", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "취소"),
            ]),
            LocalizationSection(language: "en", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
            ]),
        ]
        
        // When
        let actualSections = try table.toSections(languageFormatter: languageFormatter)
        
        // Then
        XCTAssertEqual(actualSections, expectedSections)
    }
    
    func test_toSections_withoutComment() throws {
        // Given
        let languageFormatter = StubLanguageFormatter()
        
        let table = LocalizationTable(
            header: ["Key", "ko", "en"],
            records: [
                ["cancel", "취소", "Cancel"],
                ["confirm", "확인", "Confirm"]
            ])
        
        let expectedSections: [LocalizationSection] = [
            LocalizationSection(language: "ko", items: [
                LocalizationItem(comment: nil, key: "cancel", value: "취소"),
                LocalizationItem(comment: nil, key: "confirm", value: "확인"),
            ]),
            LocalizationSection(language: "en", items: [
                LocalizationItem(comment: nil, key: "cancel", value: "Cancel"),
                LocalizationItem(comment: nil, key: "confirm", value: "Confirm"),
            ]),
        ]
        
        // When
        let actualSections = try table.toSections(languageFormatter: languageFormatter)
        
        // Then
        XCTAssertEqual(actualSections, expectedSections)
    }
    
    func test_toSections_withoutEmptyTranslationEncoding() throws {
        // Given
        let languageFormatter = StubLanguageFormatter()
        
        let table = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "", "Cancel"],
                ["confirm", "확인", "확인", "Confirm"],
            ])
        
        let expectedSections: [LocalizationSection] = [
            LocalizationSection(language: "ko", items: [
                LocalizationItem(comment: "확인", key: "confirm", value: "확인"),
            ]),
            LocalizationSection(language: "en", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
                LocalizationItem(comment: "확인", key: "confirm", value: "Confirm"),
            ]),
        ]
        
        // When
        let actualSections = try table.toSections(languageFormatter: languageFormatter,
                                                  emptyTranslationEncoding: nil)
        
        // Then
        XCTAssertEqual(actualSections, expectedSections)
    }
    
    func test_toSections_withEmptyTranslationEncoding() throws {
        // Given
        let languageFormatter = StubLanguageFormatter()
        
        let table = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "#EMPTY", "Cancel"],
                ["confirm", "확인", "확인", "Confirm"],
            ])
        
        let expectedSections: [LocalizationSection] = [
            LocalizationSection(language: "ko", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: ""),
                LocalizationItem(comment: "확인", key: "confirm", value: "확인"),
            ]),
            LocalizationSection(language: "en", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
                LocalizationItem(comment: "확인", key: "confirm", value: "Confirm"),
            ]),
        ]
        
        // When
        let actualSections = try table.toSections(languageFormatter: languageFormatter,
                                                  emptyTranslationEncoding: "#EMPTY")
        
        // Then
        XCTAssertEqual(actualSections, expectedSections)
    }
    
    func test_toSections_withWholeEmptyTranslationEncoding() throws {
        // Given
        let languageFormatter = StubLanguageFormatter()
        
        let table = LocalizationTable(
            header: ["Key", "Comment", "ko", "en"],
            records: [
                ["cancel", "취소", "", "Cancel"],
                ["confirm", "확인", "확인", "Confirm"],
            ])
        
        let expectedSections: [LocalizationSection] = [
            LocalizationSection(language: "ko", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: ""),
                LocalizationItem(comment: "확인", key: "confirm", value: "확인"),
            ]),
            LocalizationSection(language: "en", items: [
                LocalizationItem(comment: "취소", key: "cancel", value: "Cancel"),
                LocalizationItem(comment: "확인", key: "confirm", value: "Confirm"),
            ]),
        ]
        
        // When
        let actualSections = try table.toSections(languageFormatter: languageFormatter,
                                                  emptyTranslationEncoding: "")
        
        // Then
        XCTAssertEqual(actualSections, expectedSections)
    }
}
