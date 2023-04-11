import Foundation
import LocStringCore
import Strix

extension LocalizationItem {
    public var commentByRemovingFormatLabels: String? {
        guard let comment, comment.contains("%{") else {
            return comment
        }
        return (try? Parser.formatLabelRemoval.run(comment)) ?? comment
    }
    
    public var commentContainsPluralVariables: Bool {
        guard let comment, comment.contains("%") else { return false }
        
        return (try? Parser.containsPluralVariables.run(comment)) ?? false
    }
    
    public func hasCommandName(_ commandName: String) -> Bool {
        return developerComments.contains(where: { $0.hasPrefix(commandName) })
    }
}
