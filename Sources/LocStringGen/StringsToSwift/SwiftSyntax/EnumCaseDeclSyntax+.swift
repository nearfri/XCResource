import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension EnumCaseDeclSyntax {
    init(localizationItem: LocalizationItem, indent: TriviaPiece) {
        let triviaPieces: [TriviaPiece] = {
            var pieces: [TriviaPiece] = [.newlines(1)]
            
            if let documentComment = localizationItem.comment {
                let commentLine: [TriviaPiece] = [
                    indent, .newlines(1),
                    indent, .docLineComment("/// \(documentComment)"), .newlines(1),
                ]
                pieces.append(contentsOf: commentLine)
            }
            
            pieces.append(indent)
            
            return pieces
        }()
        
        let leadingTrivia = Trivia(pieces: triviaPieces)
        
        let builder = EnumCaseDecl(elementsBuilder:  {
            if localizationItem.id == localizationItem.key {
                EnumCaseElement(identifier: localizationItem.id)
            } else {
                EnumCaseElement(
                    identifier: localizationItem.id,
                    rawValue: InitializerClause(value: StringLiteralExpr(localizationItem.key)))
            }
        })
        
        self = builder.buildDecl(format: .init(), leadingTrivia: leadingTrivia).as(Self.self)!
    }
    
    func applying(_ localizationItem: LocalizationItem) -> Self {
        func checkID() -> Bool {
            return localizationItem.id == EnumCaseIdentifierExtractor().extract(from: self)
        }
        
        func checkKey() -> Bool {
            guard let rawValue = EnumCaseRawValueExtractor().extract(from: self) else {
                return true
            }
            return localizationItem.key == rawValue
        }
        
        assert(checkID())
        assert(checkKey())
        
        var result = self
        
        result = result.replacingDocumentComment(with: localizationItem.comment)
        
        return result
    }
    
    private func replacingDocumentComment(with comment: String?) -> Self {
        var leadingTrivia = leadingTrivia ?? Trivia(pieces: [])
        
        leadingTrivia = leadingTrivia.replacingDocumentComment(with: comment)
        
        return withLeadingTrivia(leadingTrivia)
    }
}
