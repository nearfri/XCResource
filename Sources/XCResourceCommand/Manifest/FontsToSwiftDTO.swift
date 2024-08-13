import Foundation
import ArgumentParser
import AssetKeyGen

struct FontsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = FontsToSwift.self
    
    var resourcesPath: String
    var fontsRelativePath: String?
    var swiftPath: String
    var keyTypeName: String
    var keyListName: String?
    var bundle: String?
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
        command.resourcesPath = resourcesPath
        command.fontsRelativePath = fontsRelativePath
        command.swiftPath = swiftPath
        command.keyTypeName = keyTypeName
        command.keyListName = keyListName
        command.bundle = bundle ?? Default.bundle
        command.accessLevel = accessLevel
        command.excludesTypeDeclation = excludesTypeDeclation ?? Default.excludesTypeDeclation
        
        return command
    }
}
