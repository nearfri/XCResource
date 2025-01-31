import Foundation
import ArgumentParser
import AssetResourceGen

struct XCAssetsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = XCAssetsToSwift.self
    
    var xcassetsPaths: [String]
    var assetTypes: [String]?
    var swiftFilePath: String
    var resourceTypeName: String
    var bundle: String?
    var accessLevel: String?
    var excludesTypeDeclaration: Bool?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = XCAssetsToSwift.Default
        
        let assetTypes = try self.assetTypes?.reduce(into: [] as [AssetType], { types, type in
            guard let assetType = AssetType(argument: type) else {
                throw ValueValidationError(key: CodingKeys.assetTypes.stringValue,
                                           value: type,
                                           valueDescription: AssetType.joinedAllValuesString)
            }
            types.append(assetType)
        })
        
        let accessLevel: AccessLevel? = try self.accessLevel.map({
            guard let level = AccessLevel(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.accessLevel.stringValue,
                    value: $0,
                    valueDescription: AccessLevel.joinedAllValuesString)
            }
            return level
        })
        
        var command = XCAssetsToSwift()
        command.assetCatalogPaths = xcassetsPaths
        command.assetTypes = assetTypes ?? Default.assetTypes
        command.swiftFilePath = swiftFilePath
        command.resourceTypeName = resourceTypeName
        command.bundle = bundle ?? Default.bundle
        command.accessLevel = accessLevel
        command.excludesTypeDeclaration = excludesTypeDeclaration ?? Default.excludesTypeDeclaration
        
        return command
    }
}
