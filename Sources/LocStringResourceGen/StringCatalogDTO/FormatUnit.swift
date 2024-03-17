import Foundation
import Strix
import StrixParsers

struct FormatUnit: Equatable {
    var placeholder: FormatPlaceholder
    var range: Range<String.Index>
    
    func applying(
        _ substitution: SubstitutionDTO,
        using parser: Parser<FormatPlaceholder>
    ) throws -> FormatUnit {
        let substitutionPlaceholder = try parser.run(substitution.formatSpecifier)
        
        var result = self
        result.placeholder.index = substitution.argNum ?? placeholder.index
        result.placeholder.length = substitutionPlaceholder.length
        result.placeholder.conversion = substitutionPlaceholder.conversion
        
        return result
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
        
        let formatSpecifier: SpecInfoParser = Parser.formatSpecifier.map({ (Optional($0), $1) })
        
        let anyCharacter: SpecInfoParser = Parser.anyCharacter.map({ (nil, $1) })
        
        return Parser.many(.attempt(formatSpecifier) <|> anyCharacter).map { specInfos in
            return specInfos.compactMap { specInfo in
                if case let .placeholder(placeholder) = specInfo.specifier {
                    let range = specInfo.substring.startIndex..<specInfo.substring.endIndex
                    return FormatUnit(placeholder: placeholder, range: range)
                }
                return nil
            }
        }
    }
}
