import Foundation
import ArgumentParser

struct KeyToStringsdictConfigurationDTO: Codable {
    var mergeStrategy: String

    func toArgument() -> KeyToStringsdictConfiguration {
        return KeyToStringsdictConfiguration(
            mergeStrategy: LocalizationMergeStrategy(argument: mergeStrategy))
    }
}

struct SwiftToStringsdictDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = SwiftToStringsdict.self
    
    var swiftPath: String
    var resourcesPath: String
    var tableName: String?
    var configurationsByLanguage: [String: KeyToStringsdictConfigurationDTO]?
    var omitsComments: Bool?
    var sortsByKey: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = SwiftToStringsdict.Default
        
        let langAndConfigs = configurationsByLanguage?.map({
            return LanguageAndStringsdictConfiguration(language: $0, configuration: $1.toArgument())
        })
        
        var command = SwiftToStringsdict()
        command.swiftPath = swiftPath
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.configurations = langAndConfigs ?? Default.configurations
        command.sortsByKey = sortsByKey ?? Default.sortsByKey
        
        return command
    }
}
