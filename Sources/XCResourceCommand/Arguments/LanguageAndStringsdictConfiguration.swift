import Foundation
import ArgumentParser
import LocStringsGen
import LocStringCore

struct LanguageAndStringsdictConfiguration: ExpressibleByArgument {
    var language: String
    var configuration: KeyToStringsdictConfiguration
    
    init(language: String, configuration: KeyToStringsdictConfiguration) {
        self.language = language
        self.configuration = configuration
    }
    
    init?(argument: String) {
        guard let separatorIndex = argument.firstIndex(of: ":") else { return nil }
        
        let language = argument[..<separatorIndex]
        if language.isEmpty { return nil }
        
        let argumentRemaining = argument[argument.index(after: separatorIndex)...]
        guard let configuration = KeyToStringsdictConfiguration(argument: String(argumentRemaining))
        else { return nil }
        
        self.language = String(language)
        self.configuration = configuration
    }
    
    var defaultValueDescription: String {
        return "\(language):\(configuration.defaultValueDescription)"
    }
    
    static var usageDescription: String {
        return "language:\(KeyToStringsdictConfiguration.usageDescription)"
    }
}

extension Array<LanguageAndStringsdictConfiguration> {
    var configurationsByLanguage: [LanguageID: KeyToStringsdictConfiguration] {
        return reduce(into: [:]) { result, each in
            result[LanguageID(each.language)] = each.configuration
        }
    }
}
