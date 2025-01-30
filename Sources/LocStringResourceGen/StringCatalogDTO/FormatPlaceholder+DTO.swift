import Foundation
import Strix
import StrixParsers

extension FormatPlaceholder {
    func applying(
        _ substitution: SubstitutionDTO,
        using parser: Parser<FormatPlaceholder>
    ) throws -> FormatPlaceholder {
        let substitutionPlaceholder = try parser.run(substitution.formatSpecifier)
        
        var result = self
        
        result.index = substitution.argNum ?? index
        result.length = substitutionPlaceholder.length
        result.conversion = substitutionPlaceholder.conversion
        
        return result
    }
}
