import Foundation
import ArgumentParser
import LocStringsGen

typealias LocalizationMergeStrategy = MergeStrategy

private enum StrategyValue {
    static let addComment: String = "comment"
    static let addKey: String = "key"
    static let doNotAdd: String = "dont-add"
}

extension LocalizationMergeStrategy: ExpressibleByArgument {
    public init(argument: String) {
        switch argument {
        case StrategyValue.addComment:  self = .add(.comment)
        case StrategyValue.addKey:      self = .add(.key)
        case StrategyValue.doNotAdd:    self = .doNotAdd
        default:                        self = .add(.label(argument))
        }
    }
    
    public var defaultValueDescription: String {
        switch self {
        case .add(let addingMethod):
            switch addingMethod {
            case .comment:          return StrategyValue.addComment
            case .key:              return StrategyValue.addKey
            case .label(let label): return label
            }
        case .doNotAdd:             return StrategyValue.doNotAdd
        }
    }
    
    public static var allValueStrings: [String] {
        return [
            StrategyValue.addComment, StrategyValue.addKey, "custom-label", StrategyValue.doNotAdd
        ]
    }
    
    static var joinedAllValuesString: String {
        return allValueStrings.joined(separator: "|")
    }
}
