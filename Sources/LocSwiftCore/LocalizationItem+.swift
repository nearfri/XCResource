import Foundation
import LocStringCore
import Strix

extension LocalizationItem {
    var commentContainsPluralVariables: Bool {
        guard let comment, comment.contains("%") else { return false }
        
        return (try? Parser.containsPluralVariables.run(comment)) ?? false
    }
}
