import Testing
import Strix
import StrixParsers
@testable import LocStringResourceGen

@Suite struct FormatPlaceholder_DTOTests {
    private let parser = Parser.formatSpecifierContent.map({ specifier in
        switch specifier {
        case .percentSign:
            preconditionFailure()
        case .placeholder(let formatPlaceholder):
            return formatPlaceholder
        }
    })
    
    @Test func applying() async throws {
        // Given
        let original = FormatPlaceholder(
            conversion: .object,
            variableName: "appleCount")
        
        let substitution = SubstitutionDTO(
            argNum: 2,
            formatSpecifier: "lld",
            variations: PluralVariationsDTO(plural: [
                "other": VariationValueDTO(
                    stringUnit: StringUnitDTO(state: "translated", value: "%arg apples"))
            ]))
        
        // When
        let applied = try original.applying(substitution, using: parser)
        
        // Then
        #expect(applied.index == 2)
        #expect(applied.length == .longLong)
        #expect(applied.conversion == .decimal)
    }
}
