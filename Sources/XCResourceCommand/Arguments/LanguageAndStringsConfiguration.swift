import Foundation
import ArgumentParser
import LocStringsGen
import LocStringCore

struct LanguageAndStringsConfiguration: ExpressibleByArgument {
    var language: String
    var configuration: KeyToStringsConfiguration
    
    init(language: String, configuration: KeyToStringsConfiguration) {
        self.language = language
        self.configuration = configuration
    }
    
    init?(argument: String) {
        guard let separatorIndex = argument.firstIndex(of: ":") else { return nil }
        
        let language = argument[..<separatorIndex]
        if language.isEmpty { return nil }
        
        let argumentRemaining = argument[argument.index(after: separatorIndex)...]
        guard let configuration = KeyToStringsConfiguration(argument: String(argumentRemaining))
        else { return nil }
        
        self.language = String(language)
        self.configuration = configuration
    }
    
    var defaultValueDescription: String {
        return "\(language):\(configuration.defaultValueDescription)"
    }
    
    static var usageDescription: String {
        return "language:\(KeyToStringsConfiguration.usageDescription)"
    }
}

extension Array<LanguageAndStringsConfiguration> {
    var configurationsByLanguage: [LanguageID: KeyToStringsConfiguration] {
        return reduce(into: [:]) { result, each in
            result[LanguageID(each.language)] = each.configuration
        }
    }
}
