import Foundation

class DefaultValueDeclarationGenerator: ValueDeclarationGenerator {
    func generate(catalog: AssetCatalog, resourceTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        var result = ""
        
        result += "// MARK: - \(catalog.name)\n"
        result += "\n"
        result += "\(accessLevel)extension \(resourceTypeName) {\n"
        
        var currentDirectoryPath = ""
        var commentPrefix = ""
        for asset in catalog.assets {
            defer { commentPrefix = "    \n" }
            let assetDirectoryPath = asset.path.deletingLastPathComponent
            if assetDirectoryPath != currentDirectoryPath {
                result += commentPrefix
                result += "    // MARK: \(assetDirectoryPath)\n"
                currentDirectoryPath = assetDirectoryPath
            }
            
            result += "    static let \(asset.id): \(resourceTypeName) = \"\(asset.name)\"\n"
        }
        
        result += "}"
        
        return result
    }
}
