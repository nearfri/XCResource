import Foundation
import ArgumentParser
import AssetResourceGen

struct FontsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = FontsToSwift.self
    
    var resourcesPath: String
    var swiftFilePath: String
    var resourceTypeName: String
    var resourceListName: String?
    var transformsToLatin: Bool?
    var stripsCombiningMarks: Bool?
    var preservesRelativePath: Bool?
    var relativePathPrefix: String?
    var bundle: String?
    var accessLevel: String?
    var excludesTypeDeclaration: Bool?
    
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
        command.swiftFilePath = swiftFilePath
        command.resourceTypeName = resourceTypeName
        command.resourceListName = resourceListName
        command.transformsToLatin = transformsToLatin ?? Default.transformsToLatin
        command.stripsCombiningMarks = {
            stripsCombiningMarks ?? Default.stripsCombiningMarks
        }()
        command.preservesRelativePath = preservesRelativePath ?? Default.preservesRelativePath
        command.relativePathPrefix = relativePathPrefix
        command.bundle = bundle ?? Default.bundle
        command.accessLevel = accessLevel
        command.excludesTypeDeclaration = excludesTypeDeclaration ?? Default.excludesTypeDeclaration
        
        return command
    }
}
