import XCTest
import LocStringCore
@testable import LocStringsGen

final class DefaultStringsLocalizationItemMergerTests: XCTestCase {
    private let sut = DefaultStringsLocalizationItemMerger()
    
    func test_itemsByMerging_strategyAdd_addNewItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "new_key", value: "", comment: "new key"),
        ]
        
        let itemsInStrings: [LocalizationItem] = []
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .add(.comment),
            verifiesComments: true)
        
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
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "missing_key", value: "Missing Key", comment: "missing key"),]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .add(.comment),
            verifiesComments: true)
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
        ])
    }
    
    func test_itemsByMerging_strategyAdd_verifyComments_setNewComment() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "greeting", value: "", comment: "new comment"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "greeting", value: "hello", comment: "old comment"),
        ]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .add(.comment),
            verifiesComments: true)
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "greeting", value: "new comment", comment: "new comment"),
        ])
    }
    
    func test_itemsByMerging_strategyAdd_notVerifyComments_keepOriginalComment() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "greeting", value: "", comment: "new comment"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "greeting", value: "hello", comment: "old comment"),
        ]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .add(.comment),
            verifiesComments: false)
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "greeting", value: "hello", comment: "new comment"),
        ])
    }
    
    // MARK: -
    
    func test_itemsByMerging_strategyDoNotAdd_doNotAddNewItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "new_key", value: "", comment: "new key"),
        ]
        
        let itemsInStrings: [LocalizationItem] = []
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .doNotAdd,
            verifiesComments: true)
        
        // Then
        XCTAssertEqual(mergedItems, [])
    }
    
    func test_itemsByMerging_strategyDoNotAdd_removeDeletedItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "cancel", value: "cancel", comment: "cancel"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
            .init(key: "missing_key", value: "Missing Key", comment: "missing key"),]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .doNotAdd,
            verifiesComments: true)
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "cancel", value: "Cancel", comment: "cancel"),
        ])
    }
    
    func test_itemsByMerging_strategyDoNotAdd_verifyComments_removeIfCommentsAreDifferent() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "greeting", value: "", comment: "new comment"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "greeting", value: "hello", comment: "old comment"),
        ]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .doNotAdd,
            verifiesComments: true)
        
        // Then
        XCTAssertEqual(mergedItems, [])
    }
    
    func test_itemsByMerging_strategyDoNotAdd_notVerifyComments_keepOriginalItem() throws {
        // Given
        let itemsInSourceCode: [LocalizationItem] = [
            .init(key: "greeting", value: "", comment: "new comment"),
        ]
        
        let itemsInStrings: [LocalizationItem] = [
            .init(key: "greeting", value: "hello", comment: "old comment"),
        ]
        
        // When
        let mergedItems = sut.itemsByMerging(
            itemsInSourceCode: itemsInSourceCode,
            itemsInStrings: itemsInStrings,
            mergeStrategy: .doNotAdd,
            verifiesComments: false)
        
        // Then
        XCTAssertEqual(mergedItems, [
            .init(key: "greeting", value: "hello", comment: "new comment"),
        ])
    }
}
