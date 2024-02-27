import Foundation
import LocStringCore
import LocSwiftCore
import SwiftSyntax
import SwiftSyntaxBuilder

extension EnumCaseDeclSyntax {
    init(localizationItem: LocalizationItem, indent: TriviaPiece) {
        let triviaPieces: [TriviaPiece] = {
            var pieces: [TriviaPiece] = [.newlines(1)]
            
            let comments: [TriviaPiece] = Self.lineComments(from: localizationItem, indent: indent)
            + Self.documentComment(from: localizationItem, indent: indent)
            
            if !comments.isEmpty {
                pieces.append(contentsOf: [indent, .newlines(1)])
                pieces.append(contentsOf: comments)
            }
            
            pieces.append(indent)
            
            return pieces
        }()
        
        self = EnumCaseDeclSyntax(leadingTrivia: Trivia(pieces: triviaPieces), elementsBuilder: {
            if localizationItem.id == localizationItem.key {
                EnumCaseElementSyntax(leadingTrivia: .space, name: .identifier(localizationItem.id))
            } else {
                EnumCaseElementSyntax(
                    leadingTrivia: .space,
                    name: .identifier(localizationItem.id),
                    rawValue: InitializerClauseSyntax(
                        equal: .equalToken(leadingTrivia: .space, trailingTrivia: .space),
                        value: StringLiteralExprSyntax(content: localizationItem.key)))
            }
        })
    }
    
    private static func lineComments(
        from localizationItem: LocalizationItem,
        indent: TriviaPiece
    ) -> [TriviaPiece] {
        var result: [TriviaPiece] = []
        
        for lineComment in localizationItem.developerComments {
            result.append(contentsOf: [
                indent, .lineComment("// \(lineComment)"), .newlines(1),
            ])
        }
        
        return result
    }
    
    private static func documentComment(
        from localizationItem: LocalizationItem,
        indent: TriviaPiece
    ) -> [TriviaPiece] {
        var result: [TriviaPiece] = []
        
        if let documentComment = localizationItem.comment {
            result.append(contentsOf: [
                indent, .docLineComment("/// \(documentComment)"), .newlines(1),
            ])
        }
        
        return result
    }
    
    func applying(_ localizationItem: LocalizationItem) -> Self {
        func checkID() -> Bool {
            let extractor = EnumCaseIdentifierExtractor(viewMode: .sourceAccurate)
            return localizationItem.id == extractor.extract(from: self)
        }
        
        func checkKey() -> Bool {
            let extractor = EnumCaseRawValueExtractor(viewMode: .sourceAccurate)
            guard let rawValue = extractor.extract(from: self) else {
                return true
            }
            return localizationItem.key == rawValue
        }
        
        assert(checkID())
        assert(checkKey())
        
        var result = self
        
        for lineComment in localizationItem.developerComments {
            result = result.addingLineComment(lineComment)
        }
        
        result = result.replacingDocumentComment(with: localizationItem.comment)
        
        return result
    }
    
    private func addingLineComment(_ comment: String) -> Self {
        return with(\.leadingTrivia, leadingTrivia.addingLineComment(comment))
    }
    
    private func replacingDocumentComment(with comment: String?) -> Self {
        return with(\.leadingTrivia, leadingTrivia.replacingDocumentComment(with: comment))
    }
}
