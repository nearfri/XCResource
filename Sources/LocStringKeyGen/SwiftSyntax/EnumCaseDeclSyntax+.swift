import Foundation
import LocStringCore
import LocSwiftCore
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
        
        self = EnumCaseDecl(leadingTrivia: Trivia(pieces: triviaPieces), elementsBuilder: {
            if localizationItem.id == localizationItem.key {
                EnumCaseElement(leadingTrivia: .space, identifier: localizationItem.id)
            } else {
                EnumCaseElement(
                    leadingTrivia: .space,
                    identifier: localizationItem.id,
                    rawValue: InitializerClause(
                        equal: .equalToken(leadingTrivia: .space, trailingTrivia: .space),
                        value: StringLiteralExpr(content: localizationItem.key)))
            }
        })
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
        
        result = result.replacingDocumentComment(with: localizationItem.comment)
        
        return result
    }
    
    private func replacingDocumentComment(with comment: String?) -> Self {
        var leadingTrivia = leadingTrivia ?? Trivia(pieces: [])
        
        leadingTrivia = leadingTrivia.replacingDocumentComment(with: comment)
        
        return withLeadingTrivia(leadingTrivia)
    }
}
