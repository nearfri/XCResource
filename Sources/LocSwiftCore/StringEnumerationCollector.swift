import Foundation
import SwiftSyntax

class StringEnumerationCollector: SyntaxVisitor {
    private let commentsExtractor: CommentsExtractor = .init()
    
    private let caseIdentifierExtractor: EnumCaseIdentifierExtractor = {
        .init(viewMode: .sourceAccurate)
    }()
    
    private let caseRawValueExtractor: EnumCaseRawValueExtractor = {
        .init(viewMode: .sourceAccurate)
    }()
    
    private(set) var enumerations: [Enumeration<String>] = []
    private var currentEnumeraion: Enumeration<String> = .init(name: "", cases: [])
    
    override func visitPost(_ node: EnumDeclSyntax) {
        currentEnumeraion.name = node.name.text
        
        enumerations.append(currentEnumeraion)
        currentEnumeraion = .init(name: "", cases: [])
    }
    
    override func visitPost(_ node: EnumCaseDeclSyntax) {
        let comments = commentsExtractor.leadingComments(in: node)
        let identifier = caseIdentifierExtractor.extract(from: node)
        let rawValue = caseRawValueExtractor.extract(from: node) ?? identifier
        
        currentEnumeraion.cases.append(
            .init(comments: comments, name: identifier, rawValue: rawValue)
        )
    }
}
