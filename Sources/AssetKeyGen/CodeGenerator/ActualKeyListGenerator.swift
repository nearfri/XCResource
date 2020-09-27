import Foundation

class ActualKeyListGenerator: KeyListGenerator {
    func generate(from catalogs: [AssetCatalog], keyTypeName: String) -> String {
        var result = ""
        
        print("extension \(keyTypeName) {", to: &result)
        print("    static let allGeneratedKeys: Set<\(keyTypeName)> = [", to: &result)
        
        var commentPrefix = ""
        for catalog in catalogs {
            defer { commentPrefix = "        \n" }
            print(commentPrefix, terminator: "", to: &result)
            print("        // MARK: \(catalog.name)", to: &result)
            for asset in catalog.assets {
                print("        .\(asset.key),", to: &result)
            }
        }
        
        print("    ]", to: &result)
        print("}", terminator: "", to: &result)
        
        return result
    }
}
