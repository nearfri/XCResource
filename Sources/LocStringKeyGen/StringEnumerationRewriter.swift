import Foundation
import LocStringCore
import LocSwiftCore
import SwiftSyntax

class StringEnumerationRewriter: SyntaxRewriter {
    private let caseIdentifierExtractor: EnumCaseIdentifierExtractor
    private let caseRawValueExtractor: EnumCaseRawValueExtractor
    
    private let difference: LocalizationDifference
    private let lineCommentForLocalizationItem: (LocalizationItem) -> String?
    
    init(difference: LocalizationDifference,
         lineCommentForLocalizationItem: @escaping (LocalizationItem) -> String?
    ) {
        self.caseIdentifierExtractor = .init(viewMode: .sourceAccurate)
        self.caseRawValueExtractor = .init(viewMode: .sourceAccurate)
        self.difference = difference
        self.lineCommentForLocalizationItem = lineCommentForLocalizationItem
    }
    
    override func visit(_ node: MemberDeclListSyntax) -> MemberDeclListSyntax {
        let indent = calculateEnumCaseIndent(from: node) ?? .spaces(4)
        
        var newNode = super.visit(node)
        
        newNode = removingBlankEnumCaseItems(from: newNode)
        
        newNode = insertingNewEnumCaseItems(to: newNode, indent: indent)
        
        newNode = trimmingEmptyLinePrefixOfFirstItem(of: newNode)
        
        return newNode
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
        
        for (index, var item) in difference.insertions {
            if index == 0, let firstItem = node.first {
                let trivia: Trivia = [.newlines(1), indent] + (firstItem.leadingTrivia ?? [])
                result = result.replacing(childAt: 0, with: firstItem.withLeadingTrivia(trivia))
            }
            
            item.developerComments = lineCommentForLocalizationItem(item).map({ [$0] }) ?? []
            
            let enumCase = EnumCaseDeclSyntax(localizationItem: item, indent: indent)
            
            result = result.inserting(MemberDeclListItemSyntax(decl: enumCase), at: index)
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
            node = EnumCaseDeclSyntax(caseKeyword: .caseKeyword(presence: .missing))
        }
        
        if var item = difference.modifications[identifier] {
            item.developerComments = lineCommentForLocalizationItem(item).map({ [$0] }) ?? []
            node = node.applying(item)
        }
        
        return super.visit(node)
    }
}
