import Foundation

class DefaultContentTreeGenerator: ContentTreeGenerator {
    func load(at url: URL) throws -> ContentTree {
        return try ContentTreeGeneratorCore(url: url).load()
    }
}

private struct ContentTreeGeneratorCore {
    let url: URL
    
    func load() throws -> ContentTree {
        let tree = ContentTree(try Content(url: url))
        
        for childURL in try childURLs() {
            guard let resourceValues = try? childURL.resourceValues(forKeys: [.isDirectoryKey]),
                  let isDirectory = resourceValues.isDirectory
            else { continue }
            
            if isDirectory {
                let childTree = try ContentTreeGeneratorCore(url: childURL).load()
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
