import Foundation
import ArgumentParser

struct LocalizationConfigurationDTO: Codable {
    var mergeStrategy: String
    var verifiesComment: Bool
    
    func toArgument() -> LocalizationConfiguration {
        return LocalizationConfiguration(
            mergeStrategy: LocalizationMergeStrategy(argument: mergeStrategy),
            verifiesComment: verifiesComment)
    }
}

struct SwiftToStringsDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = SwiftToStrings.self
    
    var swiftPath: String
    var resourcesPath: String
    var tableName: String?
    var configurationsByLanguage: [String: LocalizationConfigurationDTO]?
    var sortsByKey: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = SwiftToStrings.Default
        
        let langAndConfigs = configurationsByLanguage?.map({
            return LanguageAndConfiguration(language: $0, configuration: $1.toArgument())
        })
        
        var command = SwiftToStrings()
        command.swiftPath = swiftPath
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.languageAndConfigurations = langAndConfigs ?? Default.languageAndConfigurations
        command.sortsByKey = sortsByKey ?? Default.sortsByKey
        
        return command
    }
}
