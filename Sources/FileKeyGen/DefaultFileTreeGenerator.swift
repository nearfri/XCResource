import Foundation

class DefaultFileTreeGenerator: FileTreeGenerator {
    func load(at url: URL) throws -> FileTree {
        return try FileTreeGeneratorCore(url: url).load()
    }
}

private struct FileTreeGeneratorCore {
    let url: URL
    
    func load() throws -> FileTree {
        let tree = FileTree(FileItem(url: url))
        
        for childURL in try childURLs() {
            if childURL.isDirectoryURL == true {
                let childTree = try FileTreeGeneratorCore(url: childURL).load()
                tree.addChild(childTree)
            } else {
                let childLeaf = FileTree(FileItem(url: childURL))
                tree.addChild(childLeaf)
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
            switch (lhs.isDirectoryURL, rhs.isDirectoryURL) {
            case (false, true):
                return false
            case (true, false):
                return true
            default:
                return lhs.path.localizedStandardCompare(rhs.path) == .orderedAscending
            }
        }
    }
}

private extension URL {
    var isDirectoryURL: Bool? {
        guard let resourceValues = try? resourceValues(forKeys: [.isDirectoryKey]),
              let isDirectory = resourceValues.isDirectory
        else { return nil }
        
        return isDirectory
    }
}
