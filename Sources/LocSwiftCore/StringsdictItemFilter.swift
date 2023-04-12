import Foundation
import LocStringCore

public class StringsdictItemFilter: LocalizationItemFilter, LocalizationCommentProvider {
    private let commandNameForInclusion: String
    
    public init(commandNameForInclusion: String) {
        self.commandNameForInclusion = commandNameForInclusion
    }
    
    public func isIncluded(_ item: LocalizationItem) -> Bool {
        let isPlural = item.commentContainsPluralVariables
        let isIncluded = item.hasCommandName(commandNameForInclusion)
        return isPlural || isIncluded
    }
    
    public func lineComment(for item: LocalizationItem) -> String? {
        let isPlural = item.commentContainsPluralVariables
        return isPlural ? nil : commandNameForInclusion
    }
}
