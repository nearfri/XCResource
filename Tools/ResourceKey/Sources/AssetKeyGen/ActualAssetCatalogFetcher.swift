import Foundation

class ActualAssetCatalogFetcher: AssetCatalogFetcher {
    func fetch(at url: URL, type: AssetType) throws -> AssetCatalog {
        let containerType = ContainerType(type)
        let rootContainer = try ContainerTreeGenerator().load(contentsOf: url)
        let assets = rootContainer
            .makePreOrderSequence()
            .filter({ $0.element.type == containerType })
            .map({ Asset(name: $0.fullName, relativePath: $0.relativePath) })
        
        return AssetCatalog(name: rootContainer.fullName, assets: assets)
    }
}
