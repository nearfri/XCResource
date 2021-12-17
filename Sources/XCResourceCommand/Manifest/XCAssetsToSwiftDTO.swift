import Foundation
import ArgumentParser
import AssetKeyGen

struct XCAssetsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = XCAssetsToSwift.self
    
    var xcassetsPaths: [String]
    var assetTypes: [String]?
    var swiftPath: String
    var swiftTypeName: String
    var accessLevel: String?
    var excludesTypeDeclation: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = XCAssetsToSwift.Default
        
        let assetTypes = try self.assetTypes?.reduce(into: [] as [AssetType], { types, type in
            guard let assetType = AssetType(argument: type) else {
                throw ValueValidationError(key: CodingKeys.assetTypes.stringValue,
                                           value: type,
                                           valueDescription: AssetType.joinedValueStrings)
            }
            types.append(assetType)
        })
        
        let accessLevel: AccessLevel? = try self.accessLevel.map({
            guard let level = AccessLevel(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.accessLevel.stringValue,
                    value: $0,
                    valueDescription: AccessLevel.joinedValueStrings)
            }
            return level
        })
        
        var command = XCAssetsToSwift()
        command.assetCatalogPaths = xcassetsPaths
        command.assetTypes = assetTypes ?? Default.assetTypes
        command.swiftPath = swiftPath
        command.swiftTypeName = swiftTypeName
        command.accessLevel = accessLevel
        command.excludesTypeDeclation = excludesTypeDeclation ?? Default.excludesTypeDeclation
        
        return command
    }
}
