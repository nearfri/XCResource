import Foundation
import ArgumentParser
import LocStringResourceGen

extension LocalizationItem.BundleDescription: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
    
    public static var allValueStrings: [String] {
        return [".main", ".atURL(<url-getter>)", ".forClass(<class-type>)"]
    }
    
    static var joinedAllValuesString: String {
        return allValueStrings.joined(separator: "|")
    }
}
