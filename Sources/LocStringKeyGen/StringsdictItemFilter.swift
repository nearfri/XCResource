import Foundation
import LocStringCore
import LocSwiftCore

class StringsdictItemFilter: LocalizationItemFilter {
    func isIncluded(_ item: LocalizationItem) -> Bool {
        return item.commentContainsPluralVariables
    }
}
