import Foundation
import RegexBuilder
import SwiftSyntax
import SwiftParser

extension LocalizationItem {
    public var resolvedParameterTypes: [String] {
        guard case .method(_, let parameters) = memberDeclaration else { return [] }
        
        let parametersByAccessName = parameters.reduce(into: [:]) { partialResult, parameter in
            partialResult[parameter.accessName] = parameter
        }
        
        return defaultValueSyntax.segments.reduce(into: []) { partialResult, segment in
            guard let expSegment = segment.expressionSegmentSyntax else { return }
            
            let paramExprs = expSegment.expressions.map({ ParameterExpression(syntax: $0) })
            if paramExprs.isEmpty { return }
            
            if paramExprs.count == 2, paramExprs[1].label == "format" {
                partialResult.append("String")
                return
            }
            
            if paramExprs[0].label == "placeholder" {
                if let placeholder = paramExprs[0].expressionAsPlaceholder {
                    partialResult.append(String(placeholder))
                }
                return
            }
            
            if let parameter = parametersByAccessName[paramExprs[0].expression] {
                partialResult.append(parameter.type)
            }
        }
    }
    
    public mutating func replaceInterpolations(with other: LocalizationItem) throws {
        typealias Segment = StringLiteralSegmentListSyntax.Element
        
        var otherExpressionSegments = other.defaultValueSyntax.segments.compactMap {
            return $0.expressionSegmentSyntax
        }
        
        var newDefaultValueSyntax = defaultValueSyntax
        let newSegments: [Segment] = try newDefaultValueSyntax.segments.map { segment in
            switch segment {
            case .stringSegment(let stringSegmentSyntax):
                return .stringSegment(stringSegmentSyntax)
            case .expressionSegment(let exprSegment):
                if otherExpressionSegments.isEmpty {
                    throw SyntaxError.incompatibleInterpolationCount
                }
                var otherExprSegment = otherExpressionSegments.removeFirst()
                otherExprSegment.replaceSpecifier(with: exprSegment)
                return .expressionSegment(otherExprSegment)
            }
        }
        
        if !otherExpressionSegments.isEmpty {
            throw SyntaxError.incompatibleInterpolationCount
        }
        
        newDefaultValueSyntax.segments = .init(newSegments)
        
        defaultValue = newDefaultValueSyntax.segments.trimmedDescription
    }
    
    var defaultValueSyntax: StringLiteralExprSyntax {
        return StringLiteralExprSyntax(contentLiteral: defaultValue)
    }
}

private extension StringLiteralSegmentListSyntax.Element {
    var expressionSegmentSyntax: ExpressionSegmentSyntax? {
        switch self {
        case .stringSegment(_):
            return nil
        case .expressionSegment(let expressionSegmentSyntax):
            return expressionSegmentSyntax
        }
    }
}

private struct ParameterExpression {
    var label: String?
    var expression: String
    
    init(syntax: LabeledExprSyntax) {
        label = syntax.label?.text
        expression = syntax.expression.trimmedDescription
    }
    
    var expressionAsPlaceholder: String.LocalizationValue.Placeholder? {
        guard let placeholder = expression.split(separator: ".").last else { return nil }
        
        switch placeholder {
        case "int":     return .int
        case "uint":    return .uint
        case "float":   return .float
        case "double":  return .double
        case "object":  return .object
        default:        return nil
        }
    }
}

private extension LocalizationItem.Parameter {
    var accessName: String {
        return secondName ?? firstName
    }
}

private extension String {
    init(_ placeholder: String.LocalizationValue.Placeholder) {
        switch placeholder {
        case .int:
            self = "Int"
        case .uint:
            self = "UInt"
        case .float:
            self = "Float"
        case .double:
            self = "Double"
        case .object:
            self = "NSObject"
        @unknown default:
            self = "Never"
        }
    }
}

private extension ExpressionSegmentSyntax {
    mutating func replaceSpecifier(with other: ExpressionSegmentSyntax) {
        let specifierKey = "specifier"
        
        let specifierIndex = expressions.firstIndex(where: {
            $0.label?.text == specifierKey
        })
        let otherSpecifierIndex = other.expressions.firstIndex(where: {
            $0.label?.text == specifierKey
        })
        
        switch (specifierIndex, otherSpecifierIndex) {
        case (nil, nil):
            break
        case let (nil, otherSpecifierIndex?):
            if let lastIndex = expressions.indices.last {
                expressions[lastIndex].trailingComma = .commaToken(trailingTrivia: .space)
            }
            expressions.append(other.expressions[otherSpecifierIndex])
        case let (specifierIndex?, nil):
            if specifierIndex == expressions.indices.last {
                expressions[expressions.index(before: specifierIndex)].trailingComma = nil
            }
            expressions.remove(at: specifierIndex)
        case let (specifierIndex?, otherSpecifierIndex?):
            expressions[specifierIndex] = other.expressions[otherSpecifierIndex]
        }
    }
}

extension LocalizationItem {
    enum SyntaxError: Error {
        case incompatibleInterpolationCount
    }
}
