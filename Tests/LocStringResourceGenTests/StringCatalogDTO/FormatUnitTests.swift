import XCTest
import Strix
import StrixParsers
@testable import LocStringResourceGen

final class FormatUnitTests: XCTestCase {
    private let parser = Parser.formatSpecifierContent.map({ specifier in
        switch specifier {
        case .percentSign:
            preconditionFailure()
        case .placeholder(let formatPlaceholder):
            return formatPlaceholder
        }
    })
    
    func test_applying() throws {
        // Given
        let original = FormatUnit(
            placeholder: FormatPlaceholder(
                conversion: .object,
                variableName: "appleCount"),
            range: "".startIndex..<"".endIndex)
        
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
        XCTAssertEqual(applied.placeholder.index, 2)
        XCTAssertEqual(applied.placeholder.length, .longLong)
        XCTAssertEqual(applied.placeholder.conversion, .decimal)
    }
}

final class FormatUnitsParserTests: XCTestCase {
    private let sut: Parser<[FormatUnit]> = Parser.formatUnits
    
    func test_run_simple() throws {
        // Given
        let format = "%@ ate %lld apples today."
        
        // When
        let units = try sut.run(format)
        
        // Then
        XCTAssertEqual(units, [
            FormatUnit(
                placeholder: FormatPlaceholder(conversion: .object),
                range: format.range(of: "%@")!),
            FormatUnit(
                placeholder: FormatPlaceholder(length: .longLong, conversion: .decimal),
                range: format.range(of: "%lld")!),
        ])
    }
    
    func test_run_substitution() throws {
        // Given
        let format = "%@ ate %#@appleCount@ today."
        
        // When
        let units = try sut.run(format)
        
        // Then
        XCTAssertEqual(units, [
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
    
    func test_run_percentSignWithoutFormat() throws {
        // Given
        let format = "Battery is below 20%. Charge your phone."
        
        // When
        let units = try sut.run(format)
        
        // Then
        XCTAssertEqual(units, [])
    }
    
    func test_run_percentSignWithFormat() throws {
        // Given
        let format = "Battery is below 20%%. Charge %@."
        
        // When
        let units = try sut.run(format)
        
        // Then
        XCTAssertEqual(units, [
            FormatUnit(
                placeholder: FormatPlaceholder(conversion: .object),
                range: format.range(of: "%@")!),
        ])
    }
}
