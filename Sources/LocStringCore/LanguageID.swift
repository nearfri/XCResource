import Foundation

public struct LanguageID: Hashable, RawRepresentable, ExpressibleByStringLiteral, Sendable {
    public var rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension LanguageID {
    public static let all: LanguageID = "all"
    public static let allSymbol: String = LanguageID.all.rawValue
}

extension LanguageID: CustomStringConvertible {
    public var description: String { rawValue }
}

extension Array<LanguageID> {
    public func sorted(usingPreferredLanguages languages: [LanguageID]) -> [LanguageID] {
        return sorted { lhs, rhs in
            switch (languages.firstIndex(of: lhs), languages.firstIndex(of: rhs)) {
            case let (lhsIndex?, rhsIndex?):
                return lhsIndex < rhsIndex
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            case (nil, nil):
                return lhs.rawValue < rhs.rawValue
            }
        }
    }
}
