import Foundation
import LocStringCore
import LocSwiftCore

class StringsItemFilter: LocalizationItemFilter {
    private let commandNameForExclusion: String
    
    init(commandNameForExclusion: String) {
        self.commandNameForExclusion = commandNameForExclusion
    }
    
    func isIncluded(_ item: LocalizationItem) -> Bool {
        let isPlural = item.commentContainsPluralVariables
        let isExcluded = item.hasCommandName(commandNameForExclusion)
        return !isPlural && !isExcluded
    }
    
    func lineComment(for item: LocalizationItem) -> String? {
        return nil
    }
}
