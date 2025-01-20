import Foundation
import LocStringCore

public class StringsdictItemFilter: LocalizationItemFilter, LocalizationCommentProvider {
    private let directiveForInclusion: String
    
    public init(directiveForInclusion: String) {
        self.directiveForInclusion = directiveForInclusion
    }
    
    public func isIncluded(_ item: LocalizationItem) -> Bool {
        let isPlural = item.commentContainsPluralVariables
        let isIncluded = item.hasCommentDirective(directiveForInclusion)
        return isPlural || isIncluded
    }
    
    public func lineComment(for item: LocalizationItem) -> String? {
        let isPlural = item.commentContainsPluralVariables
        return isPlural ? nil : directiveForInclusion
    }
}
