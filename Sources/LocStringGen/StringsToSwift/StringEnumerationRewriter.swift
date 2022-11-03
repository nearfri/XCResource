import Foundation
import SwiftSyntax

class StringEnumerationRewriter: SyntaxRewriter {
    private let caseIdentifierExtractor: EnumCaseIdentifierExtractor = .init()
    private let caseRawValueExtractor: EnumCaseRawValueExtractor = .init()
    
    private let difference: LocalizationDifference
    
    init(difference: LocalizationDifference) {
        self.difference = difference
    }
    
    override func visit(_ node: MemberDeclListSyntax) -> Syntax {
        let indent = calculateEnumCaseIndent(from: node) ?? .spaces(4)
        
        var newNode = super.visit(node).as(MemberDeclListSyntax.self)!
        
        newNode = removingBlankEnumCaseItems(from: newNode)
        
        newNode = insertingNewEnumCaseItems(to: newNode, indent: indent)
        
        newNode = trimmingEmptyLinePrefixOfFirstItem(of: newNode)
        
        return Syntax(newNode)
    }
    
    private func calculateEnumCaseIndent(from node: MemberDeclListSyntax) -> TriviaPiece? {
        let firstTrivia = node.first?.leadingTrivia
        return firstTrivia?.first(where: { $0.isHorizontalWhitespaces })
    }
    
    private func removingBlankEnumCaseItems(
        from node: MemberDeclListSyntax
    ) -> MemberDeclListSyntax {
        var result = node
        
        let indicesToRemove = node.filter({ $0.totalLength == .zero }).map({ $0.indexInParent })
        
        for index in indicesToRemove.reversed() {
            result = result.removing(childAt: index)
        }
        
        return result
    }
    
    private func insertingNewEnumCaseItems(
        to node: MemberDeclListSyntax,
        indent: TriviaPiece
    ) -> MemberDeclListSyntax {
        var result = node
        
        for (index, item) in difference.insertions {
            if index == 0, let firstItem = node.first {
                let trivia: Trivia = [.newlines(1), indent] + (firstItem.leadingTrivia ?? [])
                result = result.replacing(childAt: 0, with: firstItem.withLeadingTrivia(trivia))
            }
            
            let enumCase = SyntaxFactory.makeMemberDeclListItem(
                decl: DeclSyntax(EnumCaseDeclSyntax(localizationItem: item, indent: indent)),
                semicolon: nil)
            
            result = result.inserting(enumCase, at: index)
        }
        
        return result
    }
    
    private func trimmingEmptyLinePrefixOfFirstItem(
        of node: MemberDeclListSyntax
    ) -> MemberDeclListSyntax {
        guard let firstItem = node.first, let leadingTrivia = firstItem.leadingTrivia else {
            return node
        }
        
        let newTrivia = leadingTrivia.trimmingEmptyLinePrefix()
        let newItem = firstItem.withLeadingTrivia(newTrivia)
        
        return node.replacing(childAt: firstItem.indexInParent, with: newItem)
    }
    
    override func visit(_ node: EnumCaseDeclSyntax) -> DeclSyntax {
        var node = node
        
        let identifier = caseIdentifierExtractor.extract(from: node)
        
        if difference.removals.contains(identifier) {
            node = SyntaxFactory.makeBlankEnumCaseDecl()
        }
        
        if let item = difference.modifications[identifier] {
            node = node.applying(item)
        }
        
        return super.visit(node)
    }
}
