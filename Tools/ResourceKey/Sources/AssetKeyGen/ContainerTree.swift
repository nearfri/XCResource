import Foundation
import Util

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
