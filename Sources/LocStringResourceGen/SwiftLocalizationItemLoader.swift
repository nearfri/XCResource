import Foundation
import SwiftSyntax
import SwiftParser

class SwiftLocalizationItemLoader: SourceCodeLocalizationItemLoader {
    func load(source: String, resourceTypeName: String) throws -> [LocalizationItem] {
        let visitor = SourceFileVisitor(resourceTypeName: resourceTypeName)
        visitor.walk(Parser.parse(source: source))
        
        return visitor.items
    }
}

private extension LocalizationItem {
    static var placeholder: LocalizationItem {
        LocalizationItem(key: "",
                         defaultValue: "",
                         rawDefaultValue: "",
                         memberDeclaration: .property(""))
    }
}

private class SourceFileVisitor: SyntaxVisitor {
    private let commentsExtractor: CommentsExtractor = .init()
    
    private let resourceTypeName: String
    
    private(set) var items: [LocalizationItem] = []
    private var currentItem: LocalizationItem = .placeholder
    
    private var isInExtensionDecl: Bool = false
    private var isInMemberBlockItem: Bool = false
    
    init(resourceTypeName: String) {
        self.resourceTypeName = resourceTypeName
        
        super.init(viewMode: .sourceAccurate)
    }
    
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard node.extendedType.as(IdentifierTypeSyntax.self)?.name.text == resourceTypeName else {
            return .skipChildren
        }
        
        isInExtensionDecl = true
        
        return .visitChildren
    }
    
    override func visitPost(_ node: ExtensionDeclSyntax) {
        isInExtensionDecl = false
    }
    
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard isInExtensionDecl,
              node.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) }),
              node.bindings.count == 1, let binding = node.bindings.first,
              let type = binding.typeAnnotation?.type,
              let typeToken = IdentifierTypeSyntax(type)?.name.tokenKind,
              typeToken == .keyword(.Self) || typeToken == .identifier(resourceTypeName),
              let idPattern = IdentifierPatternSyntax(binding.pattern)
        else { return .skipChildren }
        
        currentItem.developerComments = developerComments(in: node.leadingTrivia)
        currentItem.memberDeclaration = .property(idPattern.identifier.text)
        
        isInMemberBlockItem = true
        
        return .visitChildren
    }
    
    override func visitPost(_ node: VariableDeclSyntax) {
        finishCurrentItem()
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard isInExtensionDecl,
              node.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) }),
              case .identifier(let name) = node.name.tokenKind,
              let returnType = node.signature.returnClause?.type,
              let returnToken = IdentifierTypeSyntax(returnType)?.name.tokenKind,
              returnToken == .keyword(.Self) || returnToken == .identifier(resourceTypeName)
        else { return .skipChildren }
        
        let parameters = node.signature.parameterClause.parameters.map { parameterSyntax in
            parameter(from: parameterSyntax)
        }
        
        currentItem.developerComments = developerComments(in: node.leadingTrivia)
        currentItem.memberDeclaration = .method(name, parameters)
        
        isInMemberBlockItem = true
        
        return .visitChildren
    }
    
    private func parameter(from node: FunctionParameterSyntax) -> LocalizationItem.Parameter {
        return LocalizationItem.Parameter(
            firstName: node.firstName.text,
            secondName: node.secondName?.text,
            type: IdentifierTypeSyntax(node.type)?.name.text ?? "Never",
            defaultValue: node.defaultValue?.value.trimmedDescription)
    }
    
    override func visitPost(_ node: FunctionDeclSyntax) {
        finishCurrentItem()
    }
    
    private func developerComments(in trivia: Trivia) -> [String] {
        return commentsExtractor
            .comments(from: trivia)
            .filter({ $0.isForDeveloper })
            .map(\.text)
    }
    
    override func visit(_ node: LabeledExprSyntax) -> SyntaxVisitorContinueKind {
        guard isInMemberBlockItem else {
            return .skipChildren
        }
        
        switch node.label?.tokenKind {
        case nil where currentItem.key.isEmpty:
            if let stringLiteral = StringLiteralExprSyntax(node.expression) {
                currentItem.key = string(from: stringLiteral)
            }
        case .identifier("defaultValue"):
            if let stringLiteral = StringLiteralExprSyntax(node.expression) {
                currentItem.defaultValue = string(from: stringLiteral)
            }
        case .identifier("table"):
            if let stringLiteral = StringLiteralExprSyntax(node.expression) {
                currentItem.table = string(from: stringLiteral)
            }
        case .identifier("bundle"):
            currentItem.bundle = .init(rawValue: node.expression.trimmedDescription)
        default:
            break
        }
        
        return .skipChildren
    }
    
    private func string(from node: StringLiteralExprSyntax) -> String {
        return node.segments.reduce(into: "") { partialResult, segment in
            switch segment {
            case .stringSegment(let strSegment):
                partialResult += strSegment.content.text
            case .expressionSegment(let expSegment):
                partialResult += expSegment.description
            }
        }
    }
    
    private func finishCurrentItem() {
        guard isInMemberBlockItem else { return }
        
        isInMemberBlockItem = false
        
        items.append(currentItem)
        currentItem = .placeholder
    }
}
