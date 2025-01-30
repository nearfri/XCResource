import Testing
import Strix
import StrixParsers
@testable import LocStringResourceGen

@Suite struct FormatUnitsParserTests {
    private let sut: Parser<[FormatUnit]> = Parser.formatUnits
    
    @Test func run_simple() throws {
        // Given
        let format = "%@ ate %lld apples today."
        
        // When
        let units = try sut.run(format)
        
        // Then
        #expect(units == [
            FormatUnit(
                placeholder: FormatPlaceholder(conversion: .object),
                range: format.range(of: "%@")!),
            FormatUnit(
                placeholder: FormatPlaceholder(length: .longLong, conversion: .decimal),
                range: format.range(of: "%lld")!),
        ])
    }
    
    @Test func run_substitution() throws {
        // Given
        let format = "%@ ate %#@appleCount@ today."
        
        // When
        let units = try sut.run(format)
        
        // Then
        #expect(units == [
            FormatUnit(
                placeholder: FormatPlaceholder(conversion: .object),
                range: format.range(of: "%@")!),
            FormatUnit(
                placeholder: FormatPlaceholder(
                    flags: [.hash],
                    conversion: .object,
                    variableName: "appleCount"),
                range: format.range(of: "%#@appleCount@")!),
        ])
    }
    
    @Test func run_percentSignWithoutFormat() throws {
        // Given
        let format = "Battery is below 20%. Charge your phone."
        
        // When
        let units = try sut.run(format)
        
        // Then
        #expect(units == [])
    }
    
    @Test func run_percentSignWithFormat() throws {
        // Given
        let format = "Battery is below 20%%. Charge %@."
        
        // When
        let units = try sut.run(format)
        
        // Then
        #expect(units == [
            FormatUnit(specifier: .percentSign, range: format.range(of: "%%")!),
            FormatUnit(
                placeholder: FormatPlaceholder(conversion: .object),
                range: format.range(of: "%@")!),
        ])
    }
}
