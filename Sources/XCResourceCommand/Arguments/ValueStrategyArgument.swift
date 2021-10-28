import Foundation
import ArgumentParser
import LocStringGen

struct ValueStrategyArgument: ExpressibleByArgument {
    var language: String
    var strategy: LocalizableValueStrategy
    
    init(language: String, strategy: LocalizableValueStrategy) {
        self.language = language
        self.strategy = strategy
    }
    
    init?(argument: String) {
        guard let separatorIndex = argument.firstIndex(of: ":") else { return nil }
        
        let language = argument[..<separatorIndex]
        let strategy = argument[argument.index(after: separatorIndex)...]
        if language.isEmpty || strategy.isEmpty { return nil }
        
        self.language = String(language)
        self.strategy = LocalizableValueStrategy(argument: String(strategy))
    }
}

extension Array where Element == ValueStrategyArgument {
    var strategiesByLanguage: [LanguageID: LocalizableValueStrategy] {
        return reduce(into: [:]) { result, argument in
            result[LanguageID(argument.language)] = argument.strategy
        }
    }
}
