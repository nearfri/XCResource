import Foundation

class ActualAssetCatalogFetcher: AssetCatalogFetcher {
    func fetch(at url: URL) throws -> [AssetType: AssetCatalog] {
        let rootContent = try ContentTreeGenerator().load(at: url)
        return rootContent
            .makePreOrderSequence()
            .assetGroupsByType()
            .mapValues({ AssetCatalog(name: rootContent.fullName, assets: $0) })
    }
}
