import Foundation
import XCResourceUtil

typealias FileTree = Tree<FileItem>

extension FileTree {
    var url: URL {
        return element.url
    }
    
    var namespace: String {
        return element.namespace
    }
    
    var identifier: String {
        return element.identifier
    }
    
    var relativePath: String {
        guard let parent else { return "" }
        
        return parent.relativePath.appendingPathComponent(url.lastPathComponent)
    }
    
    func filter(_ regex: some RegexComponent) -> FileTree? {
        return filter { element in
            element.url.path(percentEncoded: false).contains(regex)
        }
    }
}
