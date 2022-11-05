import XCTest
@testable import LocStringGen

final class DefaultLocalizationDifferenceCalculatorTests: XCTestCase {
    private let sut: DefaultLocalizationDifferenceCalculator = .init()
    
    func test_calculate_insertions() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(id: "id1", key: "key1", value: "", comment: "text1"),
            .init(id: "id3", key: "key3", value: "", comment: "text3"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "key0", value: "", comment: "text0"),
            .init(key: "key1", value: "", comment: "text1"),
            .init(key: "key2", value: "", comment: "text2"),
            .init(key: "key3", value: "", comment: "text3"),
        ]
        
        // When
        let difference = sut.calculate(targetItems: itemsInStrings, baseItems: itemsInSourceCode)
        
        // Then
        if difference.insertions.count != 2 {
            XCTFail("insertions.count != 2")
            return
        }
        
        XCTAssertEqual(difference.insertions[0].index, 0)
        XCTAssertEqual(difference.insertions[0].item.key, "key0")
        XCTAssertEqual(difference.insertions[0].item.comment, "text0")
        
        XCTAssertEqual(difference.insertions[1].index, 2)
        XCTAssertEqual(difference.insertions[1].item.key, "key2")
        XCTAssertEqual(difference.insertions[1].item.comment, "text2")
    }
    
    func test_calculate_removals() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(id: "id0", key: "key0", value: "", comment: "text0"),
            .init(id: "id1", key: "key1", value: "", comment: "text1"),
            .init(id: "id2", key: "key2", value: "", comment: "text2"),
            .init(id: "id3", key: "key3", value: "", comment: "text3"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "key1", value: "text1", comment: ""),
            .init(key: "key3", value: "text3", comment: ""),
        ]
        
        // When
        let difference = sut.calculate(targetItems: itemsInStrings, baseItems: itemsInSourceCode)
        
        // Then
        XCTAssertEqual(difference.removals, ["id0", "id2"])
    }
    
    func test_calculate_modifications() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(id: "id0", key: "key0", value: "", comment: "%ld text0"),
            .init(id: "id1", key: "key1", value: "", comment: "%ld text1"),
            .init(id: "id2", key: "key2", value: "", comment: "%ld text2"),
            .init(id: "id3", key: "key3", value: "", comment: "%ld text3"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "key0", value: "", comment: "%ld text0-new"),
            .init(key: "key1", value: "", comment: "%ld text1"),
            .init(key: "key2", value: "", comment: "%ld text2-new"),
            .init(key: "key3", value: "", comment: "%ld text3"),
        ]
        
        // When
        let difference = sut.calculate(targetItems: itemsInStrings, baseItems: itemsInSourceCode)
        
        // Then
        XCTAssertEqual(difference.modifications, [
            "id0": .init(id: "id0", key: "key0", value: "", comment: "%ld text0-new"),
            "id2": .init(id: "id2", key: "key2", value: "", comment: "%ld text2-new"),
        ])
    }
}
