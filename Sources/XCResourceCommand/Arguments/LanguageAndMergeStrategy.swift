import Foundation
import ArgumentParser
import LocStringGen

struct LanguageAndMergeStrategy: ExpressibleByArgument {
    var language: String
    var strategy: LocalizationMergeStrategy
    
    init(language: String, strategy: LocalizationMergeStrategy) {
        self.language = language
        self.strategy = strategy
    }
    
    init?(argument: String) {
        guard let separatorIndex = argument.firstIndex(of: ":") else { return nil }
        
        let language = argument[..<separatorIndex]
        let strategy = argument[argument.index(after: separatorIndex)...]
        
        if language.isEmpty { return nil }
        
        self.language = String(language)
        self.strategy = LocalizationMergeStrategy(argument: String(strategy))
    }
    
    var defaultValueDescription: String {
        return "\(language):\(strategy.defaultValueDescription)"
    }
}

extension Array where Element == LanguageAndMergeStrategy {
    var strategiesByLanguage: [LanguageID: LocalizationMergeStrategy] {
        return reduce(into: [:]) { result, argument in
            result[LanguageID(argument.language)] = argument.strategy
        }
    }
}
