import Foundation
import LocStringCore
import LocSwiftCore

class StringsdictItemFilter: LocalizationItemFilter {
    private let commandNameForInclusion: String
    
    init(commandNameForInclusion: String) {
        self.commandNameForInclusion = commandNameForInclusion
    }
    
    func isIncluded(_ item: LocalizationItem) -> Bool {
        let isPlural = item.commentContainsPluralVariables
        let isIncluded = item.hasCommandName(commandNameForInclusion)
        return isPlural || isIncluded
    }
    
    func lineComment(for item: LocalizationItem) -> String? {
        let isPlural = item.commentContainsPluralVariables
        return isPlural ? nil : commandNameForInclusion
    }
}
