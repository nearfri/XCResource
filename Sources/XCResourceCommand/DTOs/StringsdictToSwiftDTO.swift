import Foundation
import ArgumentParser

struct StringsdictToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = StringsdictToSwift.self
    
    var resourcesPath: String
    var tableName: String?
    var language: String?
    var swiftFilePath: String
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = StringsdictToSwift.Default
        
        var command = StringsdictToSwift()
        command.resourcesPath = resourcesPath
        command.tableName = tableName ?? Default.tableName
        command.language = language ?? Default.language
        command.swiftFilePath = swiftFilePath
        
        return command
    }
}
