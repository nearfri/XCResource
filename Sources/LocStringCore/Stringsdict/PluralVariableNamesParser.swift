import Foundation
import Strix
import StrixParsers

extension Parser<[String]> {
    public static var pluralVariableNames: Parser<[String]> {
        return ParserGenerator().pluralVariableNames
    }
}

private struct ParserGenerator {
    private enum Element {
        case specifier(FormatSpecifier)
        case character
        
        var formatPlaceholder: FormatPlaceholder? {
            guard case .specifier(let specifier) = self,
                  case .placeholder(let placeholder) = specifier
            else { return nil }
            
            return placeholder
        }
    }
    
    var pluralVariableNames: Parser<[String]> {
        return pluralPlaceholders.map({ $0.compactMap(\.variableName) })
    }
    
    private var pluralPlaceholders: Parser<[FormatPlaceholder]> {
        let specifier = Parser.formatSpecifier.map({ Element.specifier($0) })
        let character = Parser.anyCharacter.map({ _ in Element.character })
        
        return Parser<[Element]>.many(specifier <|> character).map { elements in
            elements
                .compactMap({ $0.formatPlaceholder })
                .filter({ $0.isPluralVariable })
        }
    }
}
