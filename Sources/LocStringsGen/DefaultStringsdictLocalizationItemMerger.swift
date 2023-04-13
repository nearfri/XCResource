import Foundation
import LocStringCore

class DefaultStringsdictLocalizationItemMerger: StringsdictLocalizationItemMerger {
    func itemsByMerging(
        itemsInSourceCode: [LocalizationItem],
        itemsInStringsdict: [LocalizationItem],
        mergeStrategy: MergeStrategy
    ) -> [LocalizationItem] {
        switch mergeStrategy {
        case .add(let addingMethod):
            let itemsInSourceCode = itemsInSourceCode.map({ $0.applying(addingMethod) })
            return itemsByAdding(
                itemsInSourceCode: itemsInSourceCode,
                itemsInStringsdict: itemsInStringsdict)
        case .doNotAdd:
            return itemsByNotAdding(
                itemsInSourceCode: itemsInSourceCode,
                itemsInStringsdict: itemsInStringsdict)
        }
    }
    
    private func itemsByAdding(
        itemsInSourceCode: [LocalizationItem],
        itemsInStringsdict: [LocalizationItem]
    ) -> [LocalizationItem] {
        let stringsdictItemsByKey = Dictionary(
            uniqueKeysWithValues: itemsInStringsdict.map({ ($0.key, $0) }))
        
        var result = itemsInSourceCode
        
        for i in result.indices {
            guard let stringsItem = stringsdictItemsByKey[result[i].key] else { continue }
            
            result[i].value = stringsItem.value
        }
        
        return result
    }
    
    private func itemsByNotAdding(
        itemsInSourceCode: [LocalizationItem],
        itemsInStringsdict: [LocalizationItem]
    ) -> [LocalizationItem] {
        let stringsdictItemsByKey = Dictionary(
            uniqueKeysWithValues: itemsInStringsdict.map({ ($0.key, $0) }))
        
        var result: [LocalizationItem] = []
        
        for item in itemsInSourceCode {
            guard let stringsItem = stringsdictItemsByKey[item.key] else { continue }
            
            result.append(stringsItem)
        }
        
        return result
    }
}
