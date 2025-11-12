import Foundation
import Strix
import StrixParsers

struct FormatUnit: Equatable, Sendable {
    var specifier: FormatSpecifier
    var range: Range<String.Index>?
    
    var placeholder: FormatPlaceholder? {
        switch specifier {
        case .percentSign:
            return nil
        case .placeholder(let placeholder):
            return placeholder
        }
    }
}

extension FormatUnit {
    init(placeholder: FormatPlaceholder, range: Range<String.Index>?) {
        self.specifier = .placeholder(placeholder)
        self.range = range
    }
}

extension Parser where T == FormatUnit {
    static var formatUnits: Parser<[FormatUnit]> {
        return ParserGenerator().formatUnits
    }
}

private struct ParserGenerator {
    var formatUnits: Parser<[FormatUnit]> {
        typealias SpecInfoParser = Parser<(specifier: FormatSpecifier?, substring: Substring)>
        
        let formatSpecifier: SpecInfoParser = Parser.namedFormatSpecifier
            .map({ (Optional($0), $1) })
        
        let anyCharacter: SpecInfoParser = Parser.anyCharacter.map({ (nil, $1) })
        
        return Parser.many(.attempt(formatSpecifier) <|> anyCharacter).map { specInfos in
            return specInfos.compactMap { specInfo in
                if let specifier = specInfo.specifier {
                    let range = specInfo.substring.startIndex..<specInfo.substring.endIndex
                    return FormatUnit(specifier: specifier, range: range)
                }
                return nil
            }
        }
    }
}
