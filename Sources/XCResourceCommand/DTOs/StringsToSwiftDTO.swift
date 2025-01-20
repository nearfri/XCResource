import Foundation
import ArgumentParser

struct StringsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = StringsToSwift.self
    
    var resourcesPath: String
    var tableName: String?
    var language: String?
    var swiftPath: String
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = StringsToSwift.Default
        
        var command = StringsToSwift()
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.language = language ?? Default.language
        command.swiftPath = swiftPath
        
        return command
    }
}
