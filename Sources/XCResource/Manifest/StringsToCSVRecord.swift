import Foundation
import ArgumentParser
import LocStringGen

struct StringsToCSVRecord: CommandRecord {
    static let command: ParsableCommand.Type = StringsToCSV.self
    
    var resourcesPath: String
    var tableName: String?
    var developmentLanguage: String?
    var csvPath: String
    var headerStyle: String?
    var writesBOM: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = StringsToCSV.Default
        
        let headerStyle: LanguageFormatterStyle? = try self.headerStyle.map {
            guard let style = LanguageFormatterStyle(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.headerStyle.stringValue,
                    value: $0,
                    valueDescription: LanguageFormatterStyle.joinedValueStrings)
            }
            return style
        }
        
        var command = StringsToCSV()
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.developmentLanguage = developmentLanguage ?? Default.developmentLanguage
        command.csvPath = csvPath
        command.headerStyle = headerStyle ?? Default.headerStyle
        command.writesBOM = writesBOM ?? Default.writesBOM
        
        return command
    }
}
