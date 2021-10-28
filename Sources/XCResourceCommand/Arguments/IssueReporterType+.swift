import Foundation
import ArgumentParser
import LocStringGen

typealias IssueReporterType = StringFormGenerator.IssueReporterType

extension IssueReporterType: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
    
    public var defaultValueDescription: String {
        return rawValue
    }
    
    public static var allValueStrings: [String] {
        return Self.allCases.map(\.rawValue)
    }
    
    static var joinedValueStrings: String {
        return allValueStrings.joined(separator: "|")
    }
}
