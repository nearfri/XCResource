import XCTest
import Strix
@testable import LocStringCore

final class PluralVariableNamesParserTests: XCTestCase {
    private let sut: Parser<[String]> = .pluralVariableNames
    
    func test_oneVariable() throws {
        // Given
        let format = "%@ ate %#@appleCount@ today!"
        
        // When
        let variableNames = try sut.run(format)
        
        // Then
        XCTAssertEqual(variableNames, ["appleCount"])
    }
    
    func test_twoVariables() throws {
        // Given
        let format = "%@ ate %#@carrotCount@ and %#@appleCount@ today!"
        
        // When
        let variableNames = try sut.run(format)
        
        // Then
        XCTAssertEqual(variableNames, ["carrotCount", "appleCount"])
    }
}
