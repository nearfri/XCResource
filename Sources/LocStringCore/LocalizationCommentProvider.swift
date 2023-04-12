import Foundation

public protocol LocalizationCommentProvider: AnyObject {
    func lineComment(for item: LocalizationItem) -> String?
}
