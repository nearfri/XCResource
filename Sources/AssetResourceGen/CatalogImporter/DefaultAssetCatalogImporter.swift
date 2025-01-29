import Foundation

class DefaultAssetCatalogImporter: AssetCatalogImporter {
    func `import`(at url: URL) throws -> AssetCatalog {
        let rootContent = try ContentTreeGenerator().load(at: url)
        let assets = rootContent
            .makePreOrderSequence()
            .compactMap({ $0.toAsset() })
        return AssetCatalog(name: rootContent.fullName, assets: assets)
    }
}
