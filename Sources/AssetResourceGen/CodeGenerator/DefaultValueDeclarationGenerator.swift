import Foundation

class DefaultValueDeclarationGenerator: ValueDeclarationGenerator {
    func generate(for request: ValueDeclarationRequest) -> String {
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
        result += "// MARK: - \(request.contentTree.name)\n"
        result += "\n"
        result += "extension \(request.resourceTypeName) {\n"
        
        indentLevel += 1
        
        for (index, child) in request.contentTree.children.enumerated() {
            write(child, siblingIndex: index)
        }
        
        indentLevel -= 1
        
        result += "}"
        
        return result
    }
    
    private func write(_ contentTree: ContentTree, siblingIndex: Int) {
        if siblingIndex != 0 {
            result += indent + "\n"
        }
        
        switch contentTree.type {
        case .group:
            writeSubtree(contentTree)
        case .asset:
            writeLeaf(contentTree)
        }
    }
    
    private func writeSubtree(_ subtree: ContentTree) {
        if subtree.providesNamespace {
            result += "\(indent)\(accessLevel)enum \(subtree.namespace) {\n"
            indentLevel += 1
        }
        
        for (index, child) in subtree.children.enumerated() {
            write(child, siblingIndex: index)
        }
        
        if subtree.providesNamespace {
            indentLevel -= 1
            result += indent + "}\n"
        }
    }
    
    private func writeLeaf(_ leaf: ContentTree) {
        let id = leaf.identifier
        
        result += "\(indent)\(accessLevel)static let \(id): \(request.resourceTypeName) = .init(\n"
        
        indentLevel += 1
        
        result += """
            \(indent)name: "\(leaf.name)",
            \(indent)bundle: \(request.bundle))
            
            """
        
        indentLevel -= 1
    }
    
    private var indent: String {
        return String(repeating: "    ", count: indentLevel)
    }
}
