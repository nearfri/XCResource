import Foundation

class ActualKeyDeclarationGenerator: KeyDeclarationGenerator {
    func generate(from catalog: AssetCatalog, keyTypeName: String) -> String {
        var result = ""
        
        print("// MARK: - \(catalog.name)", to: &result)
        print("", to: &result)
        print("extension \(keyTypeName) {", to: &result)
        
        var currentDirectoryPath = ""
        for asset in catalog.assets {
            let assetDirectoryPath = asset.path.deletingLastPathComponent
            if assetDirectoryPath != currentDirectoryPath {
                print("    ", to: &result)
                print("    // MARK: \(assetDirectoryPath)", to: &result)
                currentDirectoryPath = assetDirectoryPath
            }
            
            print("    static let \(asset.key): \(keyTypeName) = \"\(asset.name)\"", to: &result)
        }
        
        print("    ", to: &result)
        print("}", to: &result)
        print("", to: &result)
        
        return result
    }
}
