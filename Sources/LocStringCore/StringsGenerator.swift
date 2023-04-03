import Foundation

public protocol StringsGenerator: AnyObject {
    func generate(from items: [LocalizationItem]) -> String
}
