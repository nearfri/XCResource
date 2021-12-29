import Foundation
import ArgumentParser
import LocStringGen

typealias LocalizationConfiguration = LocalizableStringsGenerator.LocalizationConfiguration

extension LocalizationConfiguration {
    enum Name {
        static let verifiesComment: String = "verify-comment"
    }
}

extension LocalizationConfiguration: ExpressibleByArgument {
    public init?(argument: String) {
        let configValues = argument.split(separator: ":", omittingEmptySubsequences: false)
        
        let mergeStrategy = LocalizationMergeStrategy(argument: String(configValues[0]))
        
        let verifiesComment: Bool
        switch configValues.count >= 2 ? configValues[1] : nil {
        case Name.verifiesComment?:
            verifiesComment = true
        case nil, "":
            verifiesComment = false
        default:
            return nil
        }
        
        self.init(mergeStrategy: mergeStrategy, verifiesComment: verifiesComment)
    }
    
    public var defaultValueDescription: String {
        var result = mergeStrategy.defaultValueDescription
        
        if verifiesComment {
            result += ":\(Name.verifiesComment)"
        }
        
        return result
    }
    
    static var usageDescription: String {
        return "<\(LocalizationMergeStrategy.joinedAllValuesString)>[:\(Name.verifiesComment)]"
    }
}
