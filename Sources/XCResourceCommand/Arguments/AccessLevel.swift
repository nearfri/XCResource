import Foundation
import ArgumentParser

enum AccessLevel: String, CaseIterable, ExpressibleByArgument, Sendable {
    case `public`
    case package
    case `internal`
    
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
    
    public var defaultValueDescription: String {
        return rawValue
    }
    
    public static var allValueStrings: [String] {
        return allCases.map(\.rawValue)
    }
    
    static var joinedAllValuesString: String {
        return allValueStrings.joined(separator: "|")
    }
}
