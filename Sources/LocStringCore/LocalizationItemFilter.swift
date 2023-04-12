import Foundation

public protocol LocalizationItemFilter: AnyObject {
    func isIncluded(_ item: LocalizationItem) -> Bool
}
