import Foundation

struct LocalizationItem: Equatable {
    var comment: String?
    var key: String
    var value: String
}

extension LocalizationItem {
    func applying(_ valueStrategy: LocalizedStringGenerator.ValueStrategy) -> LocalizationItem {
        var result = self
        
        switch valueStrategy {
        case .comment:
            result.value = result.comment ?? ""
        case .key:
            result.value = result.key
        case .custom(let string):
            result.value = string
        }
        
        return result
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
}
