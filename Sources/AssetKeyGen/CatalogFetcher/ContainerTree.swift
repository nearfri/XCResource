import Foundation
import XCResourceUtil

typealias ContainerTree = Tree<Container>

extension ContainerTree {
    var fullName: String {
        return namespace.appendingPathComponent(element.name)
    }
    
    var namespace: String {
        guard let parent = parent else { return "" }
        
        guard parent.element.providesNamespace else {
            return parent.namespace
        }
        return parent.namespace.appendingPathComponent(parent.element.name)
    }
    
    var relativePath: String {
        guard let parent = parent else { return "" }
        
        return parent.relativePath.appendingPathComponent(element.url.lastPathComponent)
    }
}

extension ContainerTree {
    func toAsset() -> Asset {
        return Asset(name: fullName, path: relativePath)
    }
}

extension Sequence where Element == ContainerTree {
    func groupsByType() -> [ContainerType: [ContainerTree]] {
        return Dictionary(grouping: self, by: \.element.type)
    }
    
    func assetGroupsByType() -> [AssetType: [Asset]] {
        return groupsByType().reduce(into: [:]) { result, each in
            guard case let .asset(assetType) = each.key else { return }
            result[assetType] = each.value.map({ $0.toAsset() })
        }
    }
}
