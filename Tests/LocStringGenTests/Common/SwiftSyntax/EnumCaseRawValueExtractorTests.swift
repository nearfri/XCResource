import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
@testable import LocStringGen

final class EnumCaseRawValueExtractorTests: XCTestCase {
    private let sut: EnumCaseRawValueExtractor = .init()
    
    func test_extract() throws {
        // Given
        let enumCase = EnumCaseDecl(elementsBuilder:  {
            EnumCaseElement(
                identifier: "hello",
                rawValue: InitializerClause(value: StringLiteralExpr("world")))
        })
        let enumCaseNode = enumCase.buildDecl(format: .init()).as(EnumCaseDeclSyntax.self)!
        
        // When
        let rawValue = sut.extract(from: enumCaseNode)
        
        // Then
        XCTAssertEqual(rawValue, "world")
    }
}
