import Foundation
import System
import XCResourceUtil

typealias FileTree = Tree<FileItem>

extension FileTree {
    var url: URL {
        return element.url
    }
    
    var relativePath: String {
        guard let parent else { return "" }
        
        return parent.relativePath.appendingPathComponent(url.lastPathComponent)
    }
    
    func filenameToNamespace() -> String {
        return url.lastPathComponent.toTypeIdentifier()
    }
    
    func filenameToIdentifier() -> String {
        return url.deletingPathExtension().lastPathComponent.toIdentifier()
    }
    
    func filter(_ regex: some RegexComponent) -> FileTree? {
        let filteredChildren: [FileTree] = children.reduce(into: []) { partialResult, child in
            if let filteredChild = child.filter(regex) {
                partialResult.append(filteredChild)
            }
        }
        
        if filteredChildren.isEmpty && !url.path(percentEncoded: false).contains(regex) {
            return nil
        }
        
        return FileTree(element, children: filteredChildren)
    }
}
