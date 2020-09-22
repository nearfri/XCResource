import Foundation

class ActualKeyDeclarationGenerator: KeyDeclarationGenerator {
    func generate(from catalog: AssetCatalog, keyTypeName: String) -> String {
        var result = ""
        
        print("// MARK: - \(catalog.name)", to: &result)
        print("", to: &result)
        print("extension \(keyTypeName) {", to: &result)
        
        var currentPath = ""
        for asset in catalog.assets {
            if asset.relativePath != currentPath {
                print("    ", to: &result)
                print("    // MARK: \(asset.relativePath)", to: &result)
                currentPath = asset.relativePath
            }
            
            print("    static let \(asset.key): \(keyTypeName) = \"\(asset.name)\"", to: &result)
        }
        
        print("    ", to: &result)
        print("}", to: &result)
        print("", to: &result)
        
        return result
    }
}
