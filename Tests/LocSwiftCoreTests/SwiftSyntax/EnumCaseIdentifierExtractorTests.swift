import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
@testable import LocSwiftCore

final class EnumCaseIdentifierExtractorTests: XCTestCase {
    private let sut: EnumCaseIdentifierExtractor = .init(viewMode: .sourceAccurate)
    
    func test_extract() throws {
        // Given
        let enumCase = EnumCaseDecl(elementsBuilder:  {
            EnumCaseElement(
                leadingTrivia: .space,
                identifier: "hello",
                rawValue: InitializerClause(
                    equal: .equalToken(leadingTrivia: .space, trailingTrivia: .space),
                    value: StringLiteralExpr(content: "world")))
        })
        
        // When
        let identifier = sut.extract(from: enumCase)
        
        // Then
        XCTAssertEqual(identifier, "hello")
    }
}
