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
            XCTFail("insertions.count != 2; insertions: \(difference.insertions.map(\.index))")
            return
        }
        
        // 0, 1, 3
        XCTAssertEqual(difference.insertions[0].index, 0)
        XCTAssertEqual(difference.insertions[0].item.key, "key0")
        XCTAssertEqual(difference.insertions[0].item.comment, "text0")
        
        // 0, 1, 2, 3
        XCTAssertEqual(difference.insertions[1].index, 2)
        XCTAssertEqual(difference.insertions[1].item.key, "key2")
        XCTAssertEqual(difference.insertions[1].item.comment, "text2")
    }
    
    func test_calculate_insertions_intoManuallySortedCases_rear() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(id: "idB1", key: "keyB1", value: "", comment: "textB1"),
            .init(id: "idA1", key: "keyA1", value: "", comment: "textA1"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "keyA1", value: "", comment: "textA1"),
            .init(key: "keyA2", value: "", comment: "textA2"),
            .init(key: "keyB1", value: "", comment: "textB1"),
            .init(key: "keyB2", value: "", comment: "textB0"),
        ]
        
        // When
        let difference = sut.calculate(targetItems: itemsInStrings, baseItems: itemsInSourceCode)
        
        // Then
        if difference.insertions.count != 2 {
            XCTFail("insertions.count != 2; insertions: \(difference.insertions.map(\.index))")
            return
        }
        
        // B1, A1, A2
        XCTAssertEqual(difference.insertions[0].index, 2)
        XCTAssertEqual(difference.insertions[0].item.key, "keyA2")
        
        // B1, B2, A1, A2
        XCTAssertEqual(difference.insertions[1].index, 1)
        XCTAssertEqual(difference.insertions[1].item.key, "keyB2")
    }
    
    func test_calculate_insertions_intoManuallySortedCases_front() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(id: "idB2", key: "keyB2", value: "", comment: "textB2"),
            .init(id: "idA1", key: "keyA1", value: "", comment: "textA1"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "keyA1", value: "", comment: "textA1"),
            .init(key: "keyA2", value: "", comment: "textA2"),
            .init(key: "keyB0", value: "", comment: "textB0"),
            .init(key: "keyB1", value: "", comment: "textB1"),
            .init(key: "keyB2", value: "", comment: "textB2"),
        ]
        
        // When
        let difference = sut.calculate(targetItems: itemsInStrings, baseItems: itemsInSourceCode)
        
        // Then
        if difference.insertions.count != 3 {
            XCTFail("insertions.count != 3; insertions: \(difference.insertions.map(\.index))")
            return
        }
        
        // B2, A1, A2
        XCTAssertEqual(difference.insertions[0].index, 2)
        XCTAssertEqual(difference.insertions[0].item.key, "keyA2")
        
        // B0, B2, A1, A2
        XCTAssertEqual(difference.insertions[1].index, 0)
        XCTAssertEqual(difference.insertions[1].item.key, "keyB0")
        
        // B0, B1, B2, A1, A2
        XCTAssertEqual(difference.insertions[2].index, 1)
        XCTAssertEqual(difference.insertions[2].item.key, "keyB1")
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
