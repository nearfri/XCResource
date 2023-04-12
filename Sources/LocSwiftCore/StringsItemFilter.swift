import Foundation
import LocStringCore

public class StringsItemFilter: LocalizationItemFilter, LocalizationCommentProvider {
    private let commandNameForExclusion: String
    
    public init(commandNameForExclusion: String) {
        self.commandNameForExclusion = commandNameForExclusion
    }
    
    public func isIncluded(_ item: LocalizationItem) -> Bool {
        let isPlural = item.commentContainsPluralVariables
        let isExcluded = item.hasCommandName(commandNameForExclusion)
        return !isPlural && !isExcluded
    }
    
    public func lineComment(for item: LocalizationItem) -> String? {
        return nil
    }
}
