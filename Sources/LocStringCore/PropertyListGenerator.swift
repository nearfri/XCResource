import Foundation

public protocol PropertyListGenerator: AnyObject {
    func generate(from items: [LocalizationItem]) -> String
}
