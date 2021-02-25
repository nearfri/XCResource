import Foundation
import Strix
import StrixParsers

class ActualFormatPlaceholderImporter: FormatPlaceholderImporter {
    private let parser: Parser<[FormatElement]> = ParserGenerator().formatElements
    
    func `import`(from string: String) throws -> [FormatPlaceholder] {
        do {
            let formatElements = try parser.run(string)
            
            return formatElements.compactMap {
                guard case let .placeholder(placeholder) = $0 else { return nil }
                return placeholder
            }
        } catch let error as Strix.RunError {
            let failureDescription = (error.failureReason ?? error.localizedDescription)
            
            throw IssueReportError(text: string,
                                   positionInText: error.position,
                                   failureDescription: failureDescription)
        }
    }
}

private enum FormatElement {
    case character(Character)
    case placeholder(FormatPlaceholder)
}

private extension StrixParsers.FormatPlaceholder {
    func toFormatPlaceholder(withLabels labels: [String]) -> FormatPlaceholder {
        return FormatPlaceholder(
            index: index,
            dynamicWidth: width?.toDynamicWidth(),
            dynamicPrecision: precision?.toDynamicPrecision(),
            valueType: formatPlaceholderType,
            labels: labels + (variableName.map({ [$0] }) ?? []))
    }
    
    private var formatPlaceholderType: Any.Type {
        switch conversion {
        case .object:
            return flags.contains(.hash) && variableName != nil ? Int.self : String.self
        default:
            return valueType
        }
    }
}

private extension StrixParsers.FormatPlaceholder.Width {
    func toDynamicWidth() -> FormatPlaceholder.DynamicWidth? {
        guard case let .dynamic(index) = self else { return nil }
        return FormatPlaceholder.DynamicWidth(index: index)
    }
    
    func toDynamicPrecision() -> FormatPlaceholder.DynamicPrecision? {
        return toDynamicWidth()
    }
}

private struct ParserGenerator {
    var formatElements: Parser<[FormatElement]> {
        return .many(placeholder <|> character)
    }
    
    private let character: Parser<FormatElement> = Parser.anyCharacter.map({ .character($0) })
    
    // `%ld{duration}` 같이 format specifier와 그 뒤에 `{}`로 감싼 레이블을 파싱한다.
    // 레이블을 파싱하지 않으려면 `%ld{{duration}` 같이 `{`을 두 번 쓴다.
    private var placeholder: Parser<FormatElement> {
        return Parser.formatSpecifier.flatMap { formatSpecifier in
            switch formatSpecifier {
            case .percentSign:
                return .just(.character("%"))
            case .placeholder(let placeholder):
                return (emptyLabelsIfDoubleBracket <|> labels <|> .just([])).map {
                    .placeholder(placeholder.toFormatPlaceholder(withLabels: $0))
                }
            }
        }
    }
    
    private let emptyLabelsIfDoubleBracket: Parser<[String]> = {
        return .lookAhead(.string("{{")) *> .character("{") *> .just([])
    }()
    
    private let labels: Parser<[String]> = {
        let labelCharacter = Parser.satisfy({ $0 != "," && $0 != "}" }, label: "label character")
        
        let label = Parser
            .many(labelCharacter)
            .map({ String($0).trimmingCharacters(in: .whitespaces) })
        
        let labels = Parser.many(label, separatedBy: Parser.character(","))
        
        return Parser.character("{") *> labels <* Parser.character("}")
    }()
}
