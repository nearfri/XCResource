import Foundation
import LocStringCore

public class StringsItemFilter: LocalizationItemFilter, LocalizationCommentProvider {
    private let directiveForExclusion: String
    
    public init(directiveForExclusion: String) {
        self.directiveForExclusion = directiveForExclusion
    }
    
    public func isIncluded(_ item: LocalizationItem) -> Bool {
        let isPlural = item.commentContainsPluralVariables
        let isExcluded = item.hasCommentDirective(directiveForExclusion)
        return !isPlural && !isExcluded
    }
    
    public func lineComment(for item: LocalizationItem) -> String? {
        return nil
    }
}
