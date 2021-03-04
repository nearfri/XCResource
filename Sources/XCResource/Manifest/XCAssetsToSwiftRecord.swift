import Foundation
import ArgumentParser
import AssetKeyGen

struct XCAssetsToSwiftRecord: CommandRecord {
    static let command: ParsableCommand.Type = XCAssetsToSwift.self
    
    var xcassetsPaths: [String]
    var assetTypes: [String]?
    var swiftPath: String
    var swiftTypeName: String
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
        
        var command = XCAssetsToSwift()
        command.assetCatalogPaths = xcassetsPaths
        command.assetTypes = assetTypes ?? Default.assetTypes
        command.swiftPath = swiftPath
        command.swiftTypeName = swiftTypeName
        command.excludesTypeDeclation = excludesTypeDeclation ?? Default.excludesTypeDeclation
        
        return command
    }
}
