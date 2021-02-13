import Foundation

class ActualKeyDeclarationGenerator: KeyDeclarationGenerator {
    func generate(catalog: AssetCatalog, keyTypeName: String) -> String {
        var result = ""
        
        print("// MARK: - \(catalog.name)", to: &result)
        print("", to: &result)
        print("extension \(keyTypeName) {", to: &result)
        
        var currentDirectoryPath = ""
        var commentPrefix = ""
        for asset in catalog.assets {
            defer { commentPrefix = "    \n" }
            let assetDirectoryPath = asset.path.deletingLastPathComponent
            if assetDirectoryPath != currentDirectoryPath {
                print(commentPrefix, terminator: "", to: &result)
                print("    // MARK: \(assetDirectoryPath)", to: &result)
                currentDirectoryPath = assetDirectoryPath
            }
            
            print("    static let \(asset.key): \(keyTypeName) = \"\(asset.name)\"", to: &result)
        }
        
        print("}", terminator: "", to: &result)
        
        return result
    }
}
