import Foundation

class ActualKeyListGenerator: KeyListGenerator {
    func generate(from catalogs: [AssetCatalog], keyTypeName: String) -> String {
        var result = ""
        
        print("extension \(keyTypeName) {", to: &result)
        print("    static let allGeneratedKeys: [\(keyTypeName)] = [", to: &result)
        
        for catalog in catalogs {
            print("        ", to: &result)
            print("        // MARK: \(catalog.name)", to: &result)
            for asset in catalog.assets {
                print("        .\(asset.key),", to: &result)
            }
        }
        
        print("        ", to: &result)
        print("    ]", to: &result)
        print("}", to: &result)
        print("", to: &result)
        
        return result
    }
}
