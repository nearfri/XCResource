import Foundation
import LocStringCore
import LocSwiftCore

extension LocalizationItem {
    func applying(
        _ addingMethod: StringKeyToStringsGenerator.MergeStrategy.AddingMethod
    ) -> LocalizationItem {
        var result = self
        
        switch addingMethod {
        case .comment:
            result.value = result.commentByRemovingFormatLabels ?? ""
        case .key:
            result.value = result.key
        case .label(let string):
            result.value = string
        }
        
        return result
    }
}

extension Array where Element == LocalizationItem {
    func combined<S>(
        with other: S,
        verifyingComments: Bool
    ) -> [LocalizationItem] where S: Sequence, S.Element == Element {
        let othersByKey = Dictionary(uniqueKeysWithValues: other.map({ ($0.key, $0) }))
        
        var result = self
        
        for i in indices {
            guard let otherItem = othersByKey[result[i].key] else { continue }
            
            if !verifyingComments || otherItem.comment == result[i].comment {
                result[i].value = otherItem.value
            }
        }
        
        return result
    }
    
    func combinedIntersection<S>(
        _ other: S,
        verifyingComments: Bool
    ) -> [LocalizationItem] where S: Sequence, S.Element == Element {
        let othersByKey = Dictionary(uniqueKeysWithValues: other.map({ ($0.key, $0) }))
        
        var result: [LocalizationItem] = []
        
        for item in self {
            guard var otherItem = othersByKey[item.key] else { continue }
            
            if !verifyingComments || otherItem.comment == item.comment {
                otherItem.comment = item.comment
                result.append(otherItem)
            }
        }
        
        return result
    }
    
    func sorted(by sortOrder: StringKeyToStringsGenerator.SortOrder) -> [LocalizationItem] {
        switch sortOrder {
        case .occurrence:
            return self
        case .key:
            return sorted(by: { $0.key < $1.key })
        }
    }
}
