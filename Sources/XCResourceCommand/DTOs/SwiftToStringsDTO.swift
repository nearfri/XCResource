import Foundation
import ArgumentParser

struct KeyToStringsConfigurationDTO: Codable, Sendable {
    var mergeStrategy: String
    var verifiesComments: Bool
    
    func toArgument() -> KeyToStringsConfiguration {
        return KeyToStringsConfiguration(
            mergeStrategy: LocalizationMergeStrategy(argument: mergeStrategy),
            verifiesComments: verifiesComments)
    }
}

struct SwiftToStringsDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = SwiftToStrings.self
    
    var swiftFilePath: String
    var resourcesPath: String
    var tableName: String?
    var configurationsByLanguage: [String: KeyToStringsConfigurationDTO]?
    var omitsComments: Bool?
    var sortsByKey: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = SwiftToStrings.Default
        
        let langAndConfigs = configurationsByLanguage?.map({
            return LanguageAndStringsConfiguration(language: $0, configuration: $1.toArgument())
        })
        
        var command = SwiftToStrings()
        command.swiftFilePath = swiftFilePath
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.configurations = langAndConfigs ?? Default.configurations
        command.omitsComments = omitsComments ?? Default.omitsComments
        command.sortsByKey = sortsByKey ?? Default.sortsByKey
        
        return command
    }
}
