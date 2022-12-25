import Foundation
import ArgumentParser
import AssetKeyGen

struct FontsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = FontsToSwift.self
    
    var fontsPath: String
    var swiftPath: String
    var keyTypeName: String
    var accessLevel: String?
    var excludesTypeDeclation: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = FontsToSwift.Default
        
        let accessLevel: AccessLevel? = try self.accessLevel.map({
            guard let level = AccessLevel(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.accessLevel.stringValue,
                    value: $0,
                    valueDescription: AccessLevel.joinedAllValuesString)
            }
            return level
        })
        
        var command = FontsToSwift()
        command.fontsPath = fontsPath
        command.swiftPath = swiftPath
        command.keyTypeName = keyTypeName
        command.accessLevel = accessLevel
        command.excludesTypeDeclation = excludesTypeDeclation ?? Default.excludesTypeDeclation
        
        return command
    }
}
