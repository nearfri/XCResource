import Foundation
import ArgumentParser
import AssetResourceGen

struct FilesToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = FilesToSwift.self
    
    var resourcesPath: String
    var filePattern: String
    var swiftFilePath: String
    var dependencies: [String]?
    var resourceTypeName: String
    var preservesRelativePath: Bool?
    var relativePathPrefix: String?
    var bundle: String?
    var accessLevel: String?
    var excludesTypeDeclaration: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = FilesToSwift.Default
        
        let accessLevel: AccessLevel? = try self.accessLevel.map({
            guard let level = AccessLevel(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.accessLevel.stringValue,
                    value: $0,
                    valueDescription: AccessLevel.joinedAllValuesString)
            }
            return level
        })
        
        var command = FilesToSwift()
        command.resourcesPath = resourcesPath
        command.filePattern = filePattern
        command.swiftFilePath = swiftFilePath
        command.dependencies = dependencies ?? Default.dependencies
        command.resourceTypeName = resourceTypeName
        command.preservesRelativePath = preservesRelativePath ?? Default.preservesRelativePath
        command.relativePathPrefix = relativePathPrefix
        command.bundle = bundle ?? Default.bundle
        command.accessLevel = accessLevel
        command.excludesTypeDeclaration = excludesTypeDeclaration ?? Default.excludesTypeDeclaration
        
        return command
    }
}
