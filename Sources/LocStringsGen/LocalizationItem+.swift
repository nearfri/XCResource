import Foundation
import LocStringCore
import LocSwiftCore

extension LocalizationItem {
    func applying(
        _ addingMethod: MergeStrategy.AddingMethod
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

extension Array<LocalizationItem> {
    func sorted(by sortOrder: SortOrder) -> [LocalizationItem] {
        switch sortOrder {
        case .occurrence:
            return self
        case .key:
            return sorted(by: { $0.key < $1.key })
        }
    }
}
