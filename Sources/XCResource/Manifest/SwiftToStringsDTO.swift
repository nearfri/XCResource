import Foundation
import ArgumentParser

struct ValueStrategyDTO: Codable {
    var language: String
    var strategy: String
    
    func toArgument() -> ValueStrategyArgument {
        return ValueStrategyArgument(language: language,
                                     strategy: LocalizableValueStrategy(argument: strategy))
    }
}

struct SwiftToStringsDTO: CommandDTO {
    static let command: ParsableCommand.Type = SwiftToStrings.self
    
    var swiftPath: String
    var resourcesPath: String
    var tableName: String?
    var languages: [String]?
    var defaultValueStrategy: String?
    var valueStrategies: [ValueStrategyDTO]?
    var sortsByKey: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = SwiftToStrings.Default
        
        let defaultValueStrategy = self.defaultValueStrategy
            .map({ LocalizableValueStrategy(argument: $0) })
        
        let valueStrategyArguments = valueStrategies?.map({ $0.toArgument() })
        
        var command = SwiftToStrings()
        command.swiftPath = swiftPath
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.languages = languages ?? Default.languages
        command.defaultValueStrategy = defaultValueStrategy ?? Default.defaultValueStrategy
        command.valueStrategyArguments = valueStrategyArguments ?? Default.valueStrategyArguments
        command.sortsByKey = sortsByKey ?? Default.sortsByKey
        
        return command
    }
}
