import Foundation
import ArgumentParser
import LocStringGen

typealias LocalizableValueStrategy = LocalizableStringsGenerator.ValueStrategy

extension LocalizableValueStrategy: ExpressibleByArgument {
    public init(argument: String) {
        switch argument {
        case "comment": self = .comment
        case "key":     self = .key
        default:        self = .custom(argument)
        }
    }
    
    public var defaultValueDescription: String {
        switch self {
        case .comment:              return "comment"
        case .key:                  return "key"
        case .custom(let string):   return string
        }
    }
    
    public static var allValueStrings: [String] {
        return ["comment", "key", "custom-string"]
    }
    
    static var joinedValueStrings: String {
        return allValueStrings.joined(separator: "|")
    }
}
