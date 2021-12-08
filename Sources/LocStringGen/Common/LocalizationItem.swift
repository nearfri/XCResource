import Foundation
import Strix

struct LocalizationItem: Equatable {
    var comment: String?
    var key: String
    var value: String
}

extension LocalizationItem {
    func applying(_ valueStrategy: LocalizableStringsGenerator.ValueStrategy) -> LocalizationItem {
        var result = self
        
        switch valueStrategy {
        case .comment:
            result.value = result.comment?.removingFormatLabels() ?? ""
        case .key:
            result.value = result.key
        case .custom(let string):
            result.value = string
        }
        
        return result
    }
    
    var commentContainsPluralVariables: Bool {
        guard let comment = comment, comment.contains("%") else { return false }
        
        return (try? Parser.containsPluralVariables.run(comment)) ?? false
    }
}

private extension String {
    func removingFormatLabels() -> String {
        if !contains("%") { return self }
        
        return (try? Parser.formatLabelRemoval.run(self)) ?? self
    }
}

extension Array where Element == LocalizationItem {
    func combining<S>(_ other: S) -> [LocalizationItem] where S: Sequence, S.Element == Element {
        let othersByKey = Dictionary(uniqueKeysWithValues: other.map({ ($0.key, $0) }))
        
        var result = self
        
        for i in result.indices {
            if let value = othersByKey[result[i].key]?.value {
                result[i].value = value
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
