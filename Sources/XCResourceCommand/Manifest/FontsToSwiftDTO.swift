import Foundation
import ArgumentParser
import AssetKeyGen

struct FontsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = FontsToSwift.self
    
    var resourcesPath: String
    var swiftPath: String
    var keyTypeName: String
    var keyListName: String?
    var preservesRelativePath: Bool?
    var relativePathPrefix: String?
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
        command.swiftPath = swiftPath
        command.keyTypeName = keyTypeName
        command.keyListName = keyListName
        command.preservesRelativePath = preservesRelativePath ?? Default.preservesRelativePath
        command.relativePathPrefix = relativePathPrefix
        command.bundle = bundle ?? Default.bundle
        command.accessLevel = accessLevel
        command.excludesTypeDeclation = excludesTypeDeclation ?? Default.excludesTypeDeclation
        
        return command
    }
}
