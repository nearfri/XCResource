import Foundation
import XCResourceUtil

typealias ContentTree = Tree<Content>

extension ContentTree {
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

extension ContentTree {
    func toAsset() -> Asset? {
        guard case .asset(let assetType) = element.type else { return nil }
        return Asset(name: fullName, path: relativePath, type: assetType)
    }
}
