import Foundation
import ArgumentParser

struct LanguageAndMergeStrategyDTO: Codable {
    var language: String
    var strategy: String
    
    func toArgument() -> LanguageAndMergeStrategy {
        return LanguageAndMergeStrategy(
            language: language,
            strategy: LocalizationMergeStrategy(argument: strategy))
    }
}

struct SwiftToStringsDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = SwiftToStrings.self
    
    var swiftPath: String
    var resourcesPath: String
    var tableName: String?
    var mergeStrategies: [LanguageAndMergeStrategyDTO]?
    var shouldCompareComments: Bool?
    var sortsByKey: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = SwiftToStrings.Default
        
        let mergeStrategies = self.mergeStrategies?.map({ $0.toArgument() })
        
        var command = SwiftToStrings()
        command.swiftPath = swiftPath
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.mergeStrategies = mergeStrategies ?? Default.mergeStrategies
        command.shouldCompareComments = shouldCompareComments ?? Default.shouldCompareComments
        command.sortsByKey = sortsByKey ?? Default.sortsByKey
        
        return command
    }
}
