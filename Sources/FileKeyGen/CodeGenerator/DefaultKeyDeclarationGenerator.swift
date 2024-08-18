import Foundation

class DefaultKeyDeclarationGenerator: KeyDeclarationGenerator {
    func generateKeyDeclarations(for request: KeyDeclarationRequest) -> String {
        return KeyDeclarationGeneratorCore(request: request).generate()
    }
}

private class KeyDeclarationGeneratorCore {
    private let request: KeyDeclarationRequest
    
    private let accessLevel: String
    
    private var result: String = ""
    
    private var indentLevel: Int = 0
    
    init(request: KeyDeclarationRequest) {
        self.request = request
        self.accessLevel = request.accessLevel.map({ $0 + " " }) ?? ""
    }
    
    func generate() -> String {
        result += "extension \(request.keyTypeName) {\n"
        
        indentLevel += 1
        
        for (index, child) in childrenToWrite().enumerated() {
            write(child, siblingIndex: index)
        }
        
        indentLevel -= 1
        
        result += "}"
        
        return result
    }
    
    private func childrenToWrite() -> [FileTree] {
        if request.preservesRelativePath {
            return request.fileTree.children
        } else {
            return request.fileTree.makePreOrderSequence().filter({ $0.isLeaf })
        }
    }
    
    private func write(_ fileTree: FileTree, siblingIndex: Int) {
        if siblingIndex != 0 {
            result += indent + "\n"
        }
        
        if fileTree.hasChildren {
            writeSubtree(fileTree)
        } else {
            writeLeaf(fileTree)
        }
    }
    
    private func writeSubtree(_ subtree: FileTree) {
        let namespace = subtree.filenameToNamespace()
        
        result += "\(indent)\(accessLevel)enum \(namespace) {\n"
        indentLevel += 1
        
        for (index, child) in subtree.children.enumerated() {
            write(child, siblingIndex: index)
        }
        
        indentLevel -= 1
        result += indent + "}\n"
    }
    
    private func writeLeaf(_ leaf: FileTree) {
        let key = leaf.filenameToKey()
        
        result += "\(indent)\(accessLevel)static let \(key): \(request.keyTypeName) = .init(\n"
        
        indentLevel += 1
        
        result += """
            \(indent)relativePath: "\(relativePath(of: leaf))",
            \(indent)bundle: \(request.bundle))
            
            """
        
        indentLevel -= 1
    }
    
    private func relativePath(of leaf: FileTree) -> String {
        var result = leaf.relativePath
        
        if !request.preservesRelativePath {
            result = result.lastPathComponent
        }
        
        if let relativePathPrefix = request.relativePathPrefix {
            result = relativePathPrefix.appendingPathComponent(result)
        }
        
        return result
    }
    
    private var indent: String {
        return String(repeating: "    ", count: indentLevel)
    }
}
