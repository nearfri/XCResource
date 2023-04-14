import Foundation
import ArgumentParser
import LocStringsGen

typealias KeyToStringsdictConfiguration = StringKeyToStringsdictGenerator.LocalizationConfiguration

extension KeyToStringsdictConfiguration: ExpressibleByArgument {
    public init?(argument: String) {
        let mergeStrategy = LocalizationMergeStrategy(argument: argument)
        
        self.init(mergeStrategy: mergeStrategy)
    }
    
    public var defaultValueDescription: String {
        return mergeStrategy.defaultValueDescription
    }
    
    static var usageDescription: String {
        return "(\(LocalizationMergeStrategy.joinedAllValuesString))"
    }
}
