import Foundation

class DefaultValueDeclarationGenerator: ValueDeclarationGenerator {
    func generateValueDeclarations(for request: ValueDeclarationRequest) -> String {
        return ValueDeclarationGeneratorCore(request: request).generate()
    }
}

private class ValueDeclarationGeneratorCore {
    private let request: ValueDeclarationRequest
    
    private let accessLevel: String
    
    private var result: String = ""
    
    private var indentLevel: Int = 0
    
    init(request: ValueDeclarationRequest) {
        self.request = request
        self.accessLevel = request.accessLevel.map({ $0 + " " }) ?? ""
    }
    
    func generate() -> String {
        result += "extension \(request.resourceTypeName) {\n"
        
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
        let id = leaf.filenameToIdentifier()
        
        result += "\(indent)\(accessLevel)static let \(id): \(request.resourceTypeName) = .init(\n"
        
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
