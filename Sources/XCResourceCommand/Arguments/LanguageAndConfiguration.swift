import Foundation
import ArgumentParser
import LocStringGen

struct LanguageAndConfiguration: ExpressibleByArgument {
    var language: String
    var configuration: LocalizationConfiguration
    
    init(language: String, configuration: LocalizationConfiguration) {
        self.language = language
        self.configuration = configuration
    }
    
    init?(argument: String) {
        guard let separatorIndex = argument.firstIndex(of: ":") else { return nil }
        
        let language = argument[..<separatorIndex]
        if language.isEmpty { return nil }
        
        let argumentRemaining = argument[argument.index(after: separatorIndex)...]
        guard let configuration = LocalizationConfiguration(argument: String(argumentRemaining))
        else { return nil }
        
        self.language = String(language)
        self.configuration = configuration
    }
    
    var defaultValueDescription: String {
        return "\(language):\(configuration.defaultValueDescription)"
    }
    
    static var usageDescription: String {
        return "language:\(LocalizationConfiguration.usageDescription)"
    }
}

extension Array where Element == LanguageAndConfiguration {
    var configurationsByLanguage: [LanguageID: LocalizationConfiguration] {
        return reduce(into: [:]) { result, each in
            result[LanguageID(each.language)] = each.configuration
        }
    }
}
