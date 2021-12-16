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
    static let commandType: ParsableCommand.Type = SwiftToStrings.self
    
    var swiftPath: String
    var resourcesPath: String
    var tableName: String?
    var valueStrategies: [ValueStrategyDTO]?
    var shouldCompareComments: Bool?
    var sortsByKey: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = SwiftToStrings.Default
        
        let valueStrategyArguments = valueStrategies?.map({ $0.toArgument() })
        
        var command = SwiftToStrings()
        command.swiftPath = swiftPath
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.valueStrategyArguments = valueStrategyArguments ?? Default.valueStrategyArguments
        command.shouldCompareComments = shouldCompareComments ?? Default.shouldCompareComments
        command.sortsByKey = sortsByKey ?? Default.sortsByKey
        
        return command
    }
}
