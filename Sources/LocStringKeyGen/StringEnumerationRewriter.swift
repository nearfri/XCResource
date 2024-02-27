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
    
    override func visit(_ node: MemberBlockItemListSyntax) -> MemberBlockItemListSyntax {
        let indent = calculateEnumCaseIndent(from: node) ?? .spaces(4)
        
        var newNode = super.visit(node)
        
        newNode = removingBlankEnumCaseItems(from: newNode)
        
        newNode = insertingNewEnumCaseItems(to: newNode, indent: indent)
        
        newNode = trimmingEmptyLinePrefixOfFirstItem(of: newNode)
        
        return newNode
    }
    
    private func calculateEnumCaseIndent(from node: MemberBlockItemListSyntax) -> TriviaPiece? {
        let firstTrivia = node.first?.leadingTrivia
        return firstTrivia?.first(where: { $0.isHorizontalWhitespaces })
    }
    
    private func removingBlankEnumCaseItems(
        from node: MemberBlockItemListSyntax
    ) -> MemberBlockItemListSyntax {
        return node.filter({ $0.totalLength != .zero })
    }
    
    private func insertingNewEnumCaseItems(
        to node: MemberBlockItemListSyntax,
        indent: TriviaPiece
    ) -> MemberBlockItemListSyntax {
        var blockItems: [MemberBlockItemSyntax] = Array(node)
        
        for (index, var item) in difference.insertions {
            if index == 0, let firstItem = node.first {
                let trivia: Trivia = [.newlines(1), indent] + firstItem.leadingTrivia
                blockItems[0] = firstItem.with(\.leadingTrivia, trivia)
            }
            
            item.developerComments = lineCommentForLocalizationItem(item).map({ [$0] }) ?? []
            
            let enumCase = EnumCaseDeclSyntax(localizationItem: item, indent: indent)
            let blockItem = MemberBlockItemSyntax(decl: enumCase)
            
            blockItems.insert(blockItem, at: index)
        }
        
        return MemberBlockItemListSyntax(blockItems)
    }
    
    private func trimmingEmptyLinePrefixOfFirstItem(
        of node: MemberBlockItemListSyntax
    ) -> MemberBlockItemListSyntax {
        guard let firstItem = node.first else {
            return node
        }
        
        let newTrivia = firstItem.leadingTrivia.trimmingEmptyLinePrefix()
        let newItem = firstItem.with(\.leadingTrivia, newTrivia)
        
        return node.with(\.[node.startIndex], newItem)
    }
    
    override func visit(_ node: EnumCaseDeclSyntax) -> DeclSyntax {
        var node = node
        
        let identifier = caseIdentifierExtractor.extract(from: node)
        
        if difference.removals.contains(identifier) {
            node = EnumCaseDeclSyntax(caseKeyword: .keyword(.case, presence: .missing),
                                      elements: [])
        }
        
        if var item = difference.modifications[identifier] {
            item.developerComments = lineCommentForLocalizationItem(item).map({ [$0] }) ?? []
            node = node.applying(item)
        }
        
        return super.visit(node)
    }
}
