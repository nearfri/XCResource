import Foundation
import ArgumentParser
import AssetKeyGen

struct FontsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = FontsToSwift.self
    
    var resourcesPath: String
    var swiftPath: String
    var keyTypeName: String
    var keyListName: String?
    var generatesLatinKey: Bool?
    var stripsCombiningMarksFromKey: Bool?
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
        command.swiftPath = swiftPath
        command.keyTypeName = keyTypeName
        command.keyListName = keyListName
        command.generatesLatinKey = generatesLatinKey ?? Default.generatesLatinKey
        command.stripsCombiningMarksFromKey = {
            stripsCombiningMarksFromKey ?? Default.stripsCombiningMarksFromKey
        }()
        command.preservesRelativePath = preservesRelativePath ?? Default.preservesRelativePath
        command.relativePathPrefix = relativePathPrefix
        command.bundle = bundle ?? Default.bundle
        command.accessLevel = accessLevel
        command.excludesTypeDeclaration = excludesTypeDeclaration ?? Default.excludesTypeDeclaration
        
        return command
    }
}
