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
        
        let insertedItems: [LocalizationItem] = [
            .init(key: "key0", value: "text0", comment: ""),
            .init(key: "key2", value: "text2", comment: ""),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            insertedItems[0],
            .init(key: "key1", value: "text1", comment: ""),
            insertedItems[1],
            .init(key: "key3", value: "text3", comment: ""),
        ]
        
        // When
        let difference = sut.calculate(targetItems: itemsInStrings, baseItems: itemsInSourceCode)
        
        // Then
        if difference.insertions.count != 2 {
            XCTFail("insertions.count != 2")
            return
        }
        
        XCTAssert(difference.insertions[0] == (0, insertedItems[0]))
        XCTAssert(difference.insertions[1] == (2, insertedItems[1]))
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
            .init(id: "id0", key: "key0", value: "", comment: "%{label}ld text0"),
            .init(id: "id1", key: "key1", value: "", comment: "%{label}ld text1"),
            .init(id: "id2", key: "key2", value: "", comment: "%{label}ld text2"),
            .init(id: "id3", key: "key3", value: "", comment: "%{label}ld text3"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "key0", value: "%ld text0-new", comment: ""),
            .init(key: "key1", value: "%ld text1", comment: ""),
            .init(key: "key2", value: "%ld text2-new", comment: ""),
            .init(key: "key3", value: "%ld text3", comment: ""),
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
