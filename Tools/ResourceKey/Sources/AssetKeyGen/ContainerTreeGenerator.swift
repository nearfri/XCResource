import Foundation

class ContainerTreeGenerator {
    func load(contentsOf url: URL) throws -> ContainerTree {
        return try GeneratorInternal(url: url).load()
    }
}

private struct GeneratorInternal {
    let url: URL
    
    func load() throws -> ContainerTree {
        let tree = ContainerTree(try Container(contentsOf: url))
        
        for childURL in try childURLs() {
            guard let resourceValues = try? childURL.resourceValues(forKeys: [.isDirectoryKey]),
                  let isDirectory = resourceValues.isDirectory else { continue }
            
            if isDirectory {
                let childTree = try GeneratorInternal(url: childURL).load()
                tree.addChild(childTree)
            }
        }
        
        return tree
    }
    
    private func childURLs() throws -> [URL] {
        let fm = FileManager.default
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey]
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]
        let childURLs = try fm.contentsOfDirectory(at: url,
                                                   includingPropertiesForKeys: resourceKeys,
                                                   options: options)
        return childURLs.sorted { lhs, rhs -> Bool in
            lhs.path.localizedStandardCompare(rhs.path) == .orderedAscending
        }
    }
}
