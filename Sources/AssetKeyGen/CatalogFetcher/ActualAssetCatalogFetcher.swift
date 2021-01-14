import Foundation

class ActualAssetCatalogFetcher: AssetCatalogFetcher {
    func fetch(at url: URL) throws -> [AssetType: AssetCatalog] {
        let rootContainer = try ContainerTreeGenerator().load(contentsOf: url)
        return rootContainer
            .makePreOrderSequence()
            .assetGroupsByType()
            .mapValues({ AssetCatalog(name: rootContainer.fullName, assets: $0) })
    }
}
