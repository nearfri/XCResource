import Foundation
import LocStringCore

struct LocalizationDifference: Sendable {
    var insertions: [(index: Int, item: LocalizationItem)] = []
    var removals: Set<LocalizationItem.ID> = []
    var modifications: [LocalizationItem.ID: LocalizationItem] = [:]
}
