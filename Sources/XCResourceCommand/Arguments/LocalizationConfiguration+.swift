import Foundation
import ArgumentParser
import LocStringsGen

typealias LocalizationConfiguration = LocalizableStringsGenerator.LocalizationConfiguration

extension LocalizationConfiguration {
    enum Name {
        static let verifiesComments: String = "verify-comments"
    }
}

extension LocalizationConfiguration: ExpressibleByArgument {
    public init?(argument: String) {
        let configValues = argument.split(separator: ":", omittingEmptySubsequences: false)
        
        let mergeStrategy = LocalizationMergeStrategy(argument: String(configValues[0]))
        
        let verifiesComments: Bool
        switch configValues.count >= 2 ? configValues[1] : nil {
        case Name.verifiesComments?:
            verifiesComments = true
        case nil, "":
            verifiesComments = false
        default:
            return nil
        }
        
        self.init(mergeStrategy: mergeStrategy, verifiesComments: verifiesComments)
    }
    
    public var defaultValueDescription: String {
        var result = mergeStrategy.defaultValueDescription
        
        if verifiesComments {
            result += ":\(Name.verifiesComments)"
        }
        
        return result
    }
    
    static var usageDescription: String {
        return "<\(LocalizationMergeStrategy.joinedAllValuesString)>[:\(Name.verifiesComments)]"
    }
}
