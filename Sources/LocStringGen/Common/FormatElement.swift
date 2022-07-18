import Foundation
import Strix
import StrixParsers

enum FormatElement: Equatable {
    case character(Character)
    case placeholder(StrixParsers.FormatPlaceholder, labels: [String])
}

extension Parser where T == [FormatElement] {
    static var formatElements: Parser<[FormatElement]> {
        return ParserGenerator().formatElements
    }
}

extension Parser where T == String {
    static var formatLabelRemoval: Parser<String> {
        return ParserGenerator().formatLabelRemoval
    }
}

extension Parser where T == Bool {
    static var containsPluralVariables: Parser<Bool> {
        return Parser.formatPlaceholders.map { placeholders in
            return placeholders.contains(where: { $0.isPluralVariable })
        }
    }
    
    private static var formatPlaceholders: Parser<[StrixParsers.FormatPlaceholder]> {
        return ParserGenerator().formatElements.map { formatElements in
            return formatElements.compactMap { formatElement in
                switch formatElement {
                case .character:
                    return nil
                case .placeholder(let placeholder, _):
                    return placeholder
                }
            }
        }
    }
}

private struct ParserGenerator {
    var formatElements: Parser<[FormatElement]> {
        return .many(placeholder <|> character)
    }
    
    var formatLabelRemoval: Parser<String> {
        let specifierOmittingLabels: Parser<String> = .character("%")
        *> labelsOrEmptyArray
        *> .skipped(by: .formatSpecifierContent).map({ "%" + $0 })
        
        return Parser.many(specifierOmittingLabels <|> Parser.skipped(by: .anyCharacter))
            .map({ $0.joined() })
    }
    
    private let character: Parser<FormatElement> = Parser.anyCharacter.map({ .character($0) })
    
    // `%{duration}ld` 같은 문법의 labeled format specifier를 파싱한다.
    private var placeholder: Parser<FormatElement> {
        let labelsAndSpecifierContent = Parser.tuple(labelsOrEmptyArray, .formatSpecifierContent)
        
        return .character("%") *> labelsAndSpecifierContent.map({
            let labels = $0.0
            let formatSpecifier = $0.1
            
            switch formatSpecifier {
            case .percentSign:
                return .character("%")
            case .placeholder(let placeholder):
                return .placeholder(placeholder, labels: labels)
            }
        })
    }
    
    private var labelsOrEmptyArray: Parser<[String]> {
        return labels <|> .just([])
    }
    
    private var labels: Parser<[String]> {
        let id = identifier
        let ws = Parser.many(.whitespace)
        let ws1 = Parser.many(.whitespace, minCount: 1)
        
        let label = Parser.many(id, separatedBy: ws1, allowEndBySeparator: true, minCount: 1)
            .map({ $0.joined(separator: " ") })
        
        let labels = Parser.many(ws *> label, separatedBy: .character(","))
        
        return Parser.character("{") *> labels <* .character("}")
    }
    
    private let identifier: Parser<String> = {
        let backtick = Parser.character("`")
        let first = Parser.letter <|> .character("_")
        let repeating = first <|> .decimalDigit
        let id = Parser.skipped(by: .many(first: first, repeating: repeating, minCount: 1))
        let idWithBacktick = Parser.skipped(by: .tuple(backtick, id, backtick))
        return idWithBacktick <|> id
    }()
}
