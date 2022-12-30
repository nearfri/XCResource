import Foundation
import LocStringCore

struct LocalizationDifference {
    var insertions: [(index: Int, item: LocalizationItem)] = []
    var removals: Set<LocalizationItem.ID> = []
    var modifications: [LocalizationItem.ID: LocalizationItem] = [:]
}
