import Foundation
import ArgumentParser
import LocStringFormGen

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
    
    static var joinedAllValuesString: String {
        return allValueStrings.joined(separator: "|")
    }
}
