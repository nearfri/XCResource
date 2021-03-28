import Foundation
import Strix
import StrixParsers

enum FormatElement {
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

private struct ParserGenerator {
    var formatElements: Parser<[FormatElement]> {
        return .many(placeholder <|> character)
    }
    
    var formatLabelRemoval: Parser<String> {
        let specifierAndOmitLabel = Parser.skipped(by: Parser.formatSpecifier) <* labelsOrEmptyArray
        
        return Parser.many(specifierAndOmitLabel <|> Parser.skipped(by: .anyCharacter))
            .map({ $0.joined() })
    }
    
    private let character: Parser<FormatElement> = Parser.anyCharacter.map({ .character($0) })
    
    // `%ld{duration}` 같이 format specifier와 그 뒤에 `{}`로 감싼 레이블을 파싱한다.
    // 레이블을 파싱하지 않으려면 `%ld{{duration}` 같이 `{`을 두 번 쓴다.
    private var placeholder: Parser<FormatElement> {
        return Parser.formatSpecifier.flatMap { [labelsOrEmptyArray] formatSpecifier in
            switch formatSpecifier {
            case .percentSign:
                return .just(.character("%"))
            case .placeholder(let placeholder):
                return labelsOrEmptyArray.map({ .placeholder(placeholder, labels: $0) })
            }
        }
    }
    
    private var labelsOrEmptyArray: Parser<[String]> {
        return emptyLabelsIfDoubleBracket <|> labels <|> .just([])
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
