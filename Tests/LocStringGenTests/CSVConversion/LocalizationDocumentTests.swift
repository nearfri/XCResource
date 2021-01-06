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
    
    static let commentedDocument: LocalizationDocument = .init(
        header: ["Key", "Comment", "ko", "en"],
        records: [
            ["cancel", "취소", "취소", "Cancel"],
            ["confirm", "확인", "확인", "Confirm"]
        ])
    
    static let nonCommentedSections: [LocalizationSection] = [
        LocalizationSection(language: "ko", items: [
            LocalizationItem(comment: nil, key: "cancel", value: "취소"),
            LocalizationItem(comment: nil, key: "confirm", value: "확인"),
        ]),
        LocalizationSection(language: "en", items: [
            LocalizationItem(comment: nil, key: "cancel", value: "Cancel"),
            LocalizationItem(comment: nil, key: "confirm", value: "Confirm"),
        ]),
    ]
    
    static let nonCommentedDocument: LocalizationDocument = .init(
        header: ["Key", "ko", "en"],
        records: [
            ["cancel", "취소", "Cancel"],
            ["confirm", "확인", "Confirm"]
        ])
}

final class LocalizationDocumentTests: XCTestCase {
    func test_validate_goodDocument_noThrow() {
        let document = Seed.commentedDocument
        XCTAssertNoThrow(try document.validate())
    }
    
    func test_validate_noKeyColumn_throw() {
        let document = LocalizationDocument(
            header: ["Comment", "ko", "en"],
            records: [
                ["취소", "취소", "Cancel"],
            ])
        XCTAssertThrowsError(try document.validate())
    }
    
    func test_validate_inconsistentColumnCount_throw() {
        let document = LocalizationDocument(
            header: ["Key", "Comment", "ko"],
            records: [
                ["cancel", "취소", "취소", "Cancel"],
            ])
        XCTAssertThrowsError(try document.validate())
    }
    
    func test_initWithSections() {
        // Given
        let sections = Seed.commentedSections
        let formatter = StubLanguageFormatter()
        let expectedDocument = Seed.commentedDocument
        
        // When
        let actualDocument = LocalizationDocument(sections: sections, formatter: formatter)
        
        // Then
        XCTAssertEqual(actualDocument, expectedDocument)
    }
    
    func test_toSections_withComment() throws {
        // Given
        let document = Seed.commentedDocument
        let expectedSections = Seed.commentedSections
        
        // When
        let actualSections = try document.toSections()
        
        // Then
        XCTAssertEqual(actualSections, expectedSections)
    }
    
    func test_toSections_withoutComment() throws {
        // Given
        let document = Seed.nonCommentedDocument
        let expectedSections = Seed.nonCommentedSections
        
        // When
        let actualSections = try document.toSections()
        
        // Then
        XCTAssertEqual(actualSections, expectedSections)
    }
}
