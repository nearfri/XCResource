import Foundation
import XCResourceUtil

typealias ContentTree = Tree<Content>

extension ContentTree {
    var type: ContentType {
        return element.type
    }
    
    var providesNamespace: Bool {
        return element.providesNamespace
    }
    
    var namespace: String {
        return element.namespace
    }
    
    var identifier: String {
        return element.identifier
    }
    
    var name: String {
        return (ancestorNamespaces + [element.name]).joined(separator: "/")
    }
    
    private var ancestorNamespaces: [String] {
        guard let parent else { return [] }
        
        return parent.ancestorNamespaces + (parent.providesNamespace ? [parent.element.name] : [])
    }
    
    func filter(matching assetTypes: Set<AssetType>) -> ContentTree? {
        return filter { element in
            switch element.type {
            case .group:
                return false
            case .asset(let assetType):
                return assetTypes.contains(assetType)
            }
        }
    }
}
