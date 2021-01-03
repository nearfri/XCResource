import Foundation

protocol PropertyListGenerator: AnyObject {
    func generate(from items: [LocalizationItem]) -> String
}
