import Foundation
import LocStringCore
import LocSwiftCore

class StringsItemFilter: LocalizationItemFilter {
    func isIncluded(_ item: LocalizationItem) -> Bool {
        return !item.commentContainsPluralVariables
    }
}
