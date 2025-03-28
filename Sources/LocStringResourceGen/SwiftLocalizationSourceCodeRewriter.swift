import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder

class SwiftLocalizationSourceCodeRewriter: LocalizationSourceCodeRewriter {
    func rewrite(
        sourceCode: String,
        with items: [LocalizationItem],
        resourceTypeName: String
    ) -> String {
        var sourceFile = Parser.parse(source: sourceCode)
        
        if !sourceFile.statements.containsImportDecl(name: "Foundation") {
            let trailingTrivia = sourceFile.statements.isEmpty ? "" : "\n"
            sourceFile.statements.insert(
                .importDeclBlockItem(name: "Foundation", trailingTrivia: trailingTrivia),
                at: sourceFile.statements.startIndex)
        }
        
        if !sourceFile.statements.containsExtensionDecl(name: resourceTypeName) {
            sourceFile.statements.append(.emptyExtensionDeclBlockItem(name: resourceTypeName))
        }
        
        let rewriter = SourceCodeRewriter(resourceTypeName: resourceTypeName, items: items)
        
        return rewriter.rewrite(sourceFile).description
    }
}

private extension CodeBlockItemListSyntax {
    func containsImportDecl(name: String) -> Bool {
        return contains { codeBlockItem in
            guard case let .decl(decl) = codeBlockItem.item,
                  let importDecl = ImportDeclSyntax(decl)
            else { return false }
            
            return importDecl.path.first?.name.text == name
        }
    }
    
    func containsExtensionDecl(name: String) -> Bool {
        return contains { codeBlockItem in
            guard case let .decl(decl) = codeBlockItem.item,
                  let extensionDecl = ExtensionDeclSyntax(decl)
            else { return false }
            
            let extensionName = extensionDecl.extendedType.as(IdentifierTypeSyntax.self)?.name.text
            return extensionName == name
        }
    }
}

private extension CodeBlockItemSyntax {
    static func importDeclBlockItem(name: String, trailingTrivia: String) -> CodeBlockItemSyntax {
        return "import \(raw: name)\(raw: trailingTrivia)"
    }
    
    static func emptyExtensionDeclBlockItem(name: String) -> CodeBlockItemSyntax {
        return """
            
            
            extension \(raw: name) {
            }
            """
    }
}

private class SourceCodeRewriter: SyntaxRewriter {
    private let resourceTypeName: String
    private let items: [LocalizationItem]
    
    private var isExtensionDeclVisited: Bool = false
    private var isInExtensionDecl: Bool = false
    
    init(resourceTypeName: String, items: [LocalizationItem]) {
        self.resourceTypeName = resourceTypeName
        self.items = items
        
        super.init()
    }
    
    override func visit(_ node: ExtensionDeclSyntax) -> DeclSyntax {
        guard !isExtensionDeclVisited,
              node.extendedType.as(IdentifierTypeSyntax.self)?.name.text == resourceTypeName
        else { return super.visit(node) }
        
        isExtensionDeclVisited = true
        
        let newMembers = MemberBlockItemListSyntax {
            for item in items {
                DeclSyntax(item)
            }
        }
        
        isInExtensionDecl = true
        defer { isInExtensionDecl = false }
        
        return super.visit(node.with(\.memberBlock.members, newMembers))
    }
    
    override func visit(_ node: MemberBlockItemSyntax) -> MemberBlockItemSyntax {
        guard isInExtensionDecl,
              let parent = node.parent?.as(MemberBlockItemListSyntax.self)
        else { return super.visit(node) }
        
        let isFirstMember = parent.index(of: node) == parent.startIndex
        
        // Indenter 특성 상 .newlines(2)이 아니라 .newlines(1) 2개를 넣어야 한다.
        let newlines: [TriviaPiece] = isFirstMember ? [.newlines(1)] : [.newlines(1), .newlines(1)]
        let leadingTrivia = Trivia(pieces: newlines + node.leadingTrivia.pieces)
        
        let indentedNode = IndentIncreaser.indent(
            node.with(\.leadingTrivia, leadingTrivia),
            indentation: .spaces(4))
        
        return super.visit(indentedNode)
    }
}
