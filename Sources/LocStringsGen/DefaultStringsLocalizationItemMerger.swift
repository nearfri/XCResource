import Foundation
import LocStringCore

class DefaultStringsLocalizationItemMerger: StringsLocalizationItemMerger {
    func itemsByMerging(
        itemsInSourceCode: [LocalizationItem],
        itemsInStrings: [LocalizationItem],
        mergeStrategy: MergeStrategy,
        verifiesComments: Bool
    ) -> [LocalizationItem] {
        switch mergeStrategy {
        case .add(let addingMethod):
            let itemsInSourceCode = itemsInSourceCode.map({ $0.applying(addingMethod) })
            return itemsByAdding(
                itemsInSourceCode: itemsInSourceCode,
                itemsInStrings: itemsInStrings,
                verifiesComments: verifiesComments)
        case .doNotAdd:
            return itemsByNotAdding(
                itemsInSourceCode: itemsInSourceCode,
                itemsInStrings: itemsInStrings,
                verifiesComments: verifiesComments)
        }
    }
    
    private func itemsByAdding(
        itemsInSourceCode: [LocalizationItem],
        itemsInStrings: [LocalizationItem],
        verifiesComments: Bool
    ) -> [LocalizationItem] {
        let stringsItemsByKey = Dictionary(
            uniqueKeysWithValues: itemsInStrings.map({ ($0.key, $0) }))
        
        var result = itemsInSourceCode
        
        for i in result.indices {
            guard let stringsItem = stringsItemsByKey[result[i].key] else { continue }
            
            if !verifiesComments || stringsItem.comment == result[i].comment {
                result[i].value = stringsItem.value
            }
        }
        
        return result
    }
    
    private func itemsByNotAdding(
        itemsInSourceCode: [LocalizationItem],
        itemsInStrings: [LocalizationItem],
        verifiesComments: Bool
    ) -> [LocalizationItem] {
        let stringsItemsByKey = Dictionary(
            uniqueKeysWithValues: itemsInStrings.map({ ($0.key, $0) }))
        
        var result: [LocalizationItem] = []
        
        for item in itemsInSourceCode {
            guard var stringsItem = stringsItemsByKey[item.key] else { continue }
            
            if !verifiesComments || stringsItem.comment == item.comment {
                stringsItem.comment = item.comment
                result.append(stringsItem)
            }
        }
        
        return result
    }
}
