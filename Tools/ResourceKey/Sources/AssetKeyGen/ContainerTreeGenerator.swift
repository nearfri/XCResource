import Foundation

typealias ContainerTree = Tree<Container>

class ContainerTreeGenerator {
    func load(contentsOf url: URL) throws -> ContainerTree {
        return try GeneratorInternal(url: url).load()
    }
}

private struct GeneratorInternal {
    let url: URL
    
    func load() throws -> ContainerTree {
        let tree = Tree(try Container(contentsOf: url))
        for case let childURL as URL in try makeShallowDirectoryEnumerator() {
            guard let resourceValues = try? childURL.resourceValues(forKeys: [.isDirectoryKey]),
                  let isDirectory = resourceValues.isDirectory else { continue }
            
            if isDirectory {
                let childTree = try GeneratorInternal(url: childURL).load()
                tree.addChild(childTree)
            }
        }
        return tree
    }
    
    private func makeShallowDirectoryEnumerator() throws -> FileManager.DirectoryEnumerator {
        let fm = FileManager.default
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey]
        let options: FileManager.DirectoryEnumerationOptions = [
            .skipsHiddenFiles, .skipsSubdirectoryDescendants
        ]
        
        let enumerator = fm.enumerator(at: url,
                                       includingPropertiesForKeys: resourceKeys,
                                       options: options)
        guard let result = enumerator else {
            throw NSError(domain: URLError.errorDomain,
                          code: URLError.fileDoesNotExist.rawValue,
                          userInfo: nil)
        }
        return result
    }
}
