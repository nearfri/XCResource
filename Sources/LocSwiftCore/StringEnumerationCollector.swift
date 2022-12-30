import Foundation
import SwiftSyntax

class StringEnumerationCollector: SyntaxVisitor {
    private let commentsExtractor: CommentsExtractor = .init()
    private let caseIdentifierExtractor: EnumCaseIdentifierExtractor = .init()
    private let caseRawValueExtractor: EnumCaseRawValueExtractor = .init()
    
    private(set) var enumerations: [Enumeration<String>] = []
    private var currentEnumeraion: Enumeration<String> = .init(identifier: "", cases: [])
    
    override func visitPost(_ node: EnumDeclSyntax) {
        let id: TokenSyntax = node.identifier
        currentEnumeraion.identifier = id.text
        
        enumerations.append(currentEnumeraion)
        currentEnumeraion = .init(identifier: "", cases: [])
    }
    
    override func visitPost(_ node: EnumCaseDeclSyntax) {
        let comments = commentsExtractor.leadingComments(in: node)
        let identifier = caseIdentifierExtractor.extract(from: node)
        let rawValue = caseRawValueExtractor.extract(from: node) ?? identifier
        
        currentEnumeraion.cases.append(
            .init(comments: comments, identifier: identifier, rawValue: rawValue)
        )
    }
}
