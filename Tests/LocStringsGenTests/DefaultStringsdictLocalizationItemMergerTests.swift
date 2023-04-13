import XCTest
import LocStringCore
@testable import LocStringsGen

final class DefaultStringsdictLocalizationItemMergerTests: XCTestCase {
    private let sut = DefaultStringsdictLocalizationItemMerger()
    
    func test_itemsByMerging_strategyAdd_addNewItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "new_key", value: "", comment: "new key"),
        ]
        
        let itemsInStringsdict: [LocalizationItem] = []
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStringsdict: itemsInStringsdict,
            mergeStrategy: .add(.comment))
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "new_key", value: "new key", comment: "new key"),
        ])
    }
    
    func test_itemsByMerging_strategyAdd_removeDeletedItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "cancel", value: "cancel", comment: "cancel"),
        ]
        
        let itemsInStringsdict: [LocalizationItem] = [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "missing_key", value: "Missing Key", comment: "missing key"),]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStringsdict: itemsInStringsdict,
            mergeStrategy: .add(.comment))
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
        ])
    }
    
    // MARK: -
    
    func test_itemsByMerging_strategyDoNotAdd_doNotAddNewItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "new_key", value: "", comment: "new key"),
        ]
        
        let itemsInStringsdict: [LocalizationItem] = []
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStringsdict: itemsInStringsdict,
            mergeStrategy: .doNotAdd)
        
        // Then
        XCTAssertEqual(mergedItems, [])
    }
    
    func test_itemsByMerging_strategyDoNotAdd_removeDeletedItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "cancel", value: "cancel", comment: "cancel"),
        ]
        
        let itemsInStringsdict: [LocalizationItem] = [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "missing_key", value: "Missing Key", comment: "missing key"),]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStringsdict: itemsInStringsdict,
            mergeStrategy: .doNotAdd)
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
        ])
    }
}
