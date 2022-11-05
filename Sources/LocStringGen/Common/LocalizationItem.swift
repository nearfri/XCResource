import Foundation
import Strix

struct LocalizationItem: Equatable, Identifiable {
    let id: String
    var key: String
    var value: String
    var comment: String?
}

extension LocalizationItem {
    init(key: String, value: String, comment: String? = nil) {
        self.id = key
        self.key = key
        self.value = value
        self.comment = comment
    }
}

extension LocalizationItem {
    func applying(
        _ addingMethod: LocalizableStringsGenerator.MergeStrategy.AddingMethod
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
    
    var commentByRemovingFormatLabels: String? {
        guard let comment, comment.contains("%{") else {
            return comment
        }
        return (try? Parser.formatLabelRemoval.run(comment)) ?? comment
    }
    
    var commentContainsPluralVariables: Bool {
        guard let comment, comment.contains("%") else { return false }
        
        return (try? Parser.containsPluralVariables.run(comment)) ?? false
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
    
    func sorted(by sortOrder: LocalizableStringsGenerator.SortOrder) -> [LocalizationItem] {
        switch sortOrder {
        case .occurrence:
            return self
        case .key:
            return sorted(by: { $0.key < $1.key })
        }
    }
}
