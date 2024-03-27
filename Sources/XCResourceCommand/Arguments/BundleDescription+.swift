import Foundation
import ArgumentParser
import LocStringResourceGen

extension LocalizationItem.BundleDescription: ExpressibleByArgument {
    public init?(argument: String) {
        let separatorIndex = argument.firstIndex(of: ":")
        
        let type = argument[..<(separatorIndex ?? argument.endIndex)]
        
        let associatedValue = separatorIndex.map({
            String(argument[argument.index(after: $0)...])
        }) ?? ""
        
        switch type {
        case "main":
            self = .main
        case "at-url":
            self = .atURL(associatedValue)
        case "for-class":
            self = .forClass(associatedValue)
        default:
            return nil
        }
    }
    
    public var defaultValueDescription: String {
        switch self {
        case .main:
            return "main"
        case .atURL(let urlGetter):
            return "at-url:\(urlGetter)"
        case .forClass(let classType):
            return "for-class:\(classType)"
        }
    }
    
    public static var allValueStrings: [String] {
        return ["main", "at-url:<url-getter>", "for-class:<class-type>"]
    }
    
    static var joinedAllValuesString: String {
        return allValueStrings.joined(separator: "|")
    }
}
