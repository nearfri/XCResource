import Foundation
import ArgumentParser
import LocStringGen

struct CSVToStringsDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = CSVToStrings.self
    
    var csvPath: String
    var headerStyle: String?
    var resourcesPath: String
    var tableName: String?
    var emptyEncoding: String?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = CSVToStrings.Default
        
        let headerStyle: LanguageFormatterStyle? = try self.headerStyle.map {
            guard let style = LanguageFormatterStyle(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.headerStyle.stringValue,
                    value: $0,
                    valueDescription: LanguageFormatterStyle.joinedAllValuesString)
            }
            return style
        }
        
        var command = CSVToStrings()
        command.csvPath = csvPath
        command.headerStyle = headerStyle ?? Default.headerStyle
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.emptyEncoding = emptyEncoding
        
        return command
    }
}
