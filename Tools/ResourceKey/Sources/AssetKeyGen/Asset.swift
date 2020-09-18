import Foundation


// Node, Asset, Folder, Group, Leaf
// keyPath, contentType("", images, colors
protocol AssetNode: AnyObject {
    var parent: AssetGroup? { get set }
    var name: String { get }
    //    var namespace: String { get }
}

protocol AssetGroup: AssetNode {
    func addChild(_ child: AssetNode)
    func allLeafChildren() -> [AssetNode]
}

enum AssetType {
    case image, color
}

class AssetSet: AssetNode {
    weak var parent: AssetGroup?
    var type: AssetType
    var name: String
    
    init(type: AssetType, name: String) {
        self.type = type
        self.name = name
    }
}

class AssetFolder: AssetGroup {
    weak var parent: AssetGroup?
    var name: String
    var providesNamespace: Bool
    var children: [AssetNode] = []
    
    init(name: String, providesNamespace: Bool) {
        self.name = name
        self.providesNamespace = providesNamespace
    }
    
    func addChild(_ child: AssetNode) {
        children.append(child)
        child.parent = self
    }
    
    func allLeafChildren() -> [AssetNode] {
        return children.reduce(into: []) { result, child in
            if let child = child as? AssetGroup {
                result.append(contentsOf: child.allLeafChildren())
            } else {
                result.append(child)
            }
        }
    }
}
