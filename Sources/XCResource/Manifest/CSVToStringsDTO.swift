import Foundation
import ArgumentParser
import LocStringGen

struct CSVToStringsDTO: CommandDTO {
    static let command: ParsableCommand.Type = CSVToStrings.self
    
    var csvPath: String
    var headerStyle: String?
    var resourcesPath: String
    var tableName: String?
    var includesEmptyFields: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = CSVToStrings.Default
        
        let headerStyle: LanguageFormatterStyle? = try self.headerStyle.map {
            guard let style = LanguageFormatterStyle(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.headerStyle.stringValue,
                    value: $0,
                    valueDescription: LanguageFormatterStyle.joinedValueStrings)
            }
            return style
        }
        
        var command = CSVToStrings()
        command.csvPath = csvPath
        command.headerStyle = headerStyle ?? Default.headerStyle
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.includesEmptyFields = includesEmptyFields ?? Default.includesEmptyFields
        
        return command
    }
}
