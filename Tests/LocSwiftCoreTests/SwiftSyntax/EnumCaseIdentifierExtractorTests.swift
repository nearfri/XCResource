import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
@testable import LocSwiftCore

final class EnumCaseIdentifierExtractorTests: XCTestCase {
    private let sut: EnumCaseIdentifierExtractor = .init(viewMode: .sourceAccurate)
    
    func test_extract() throws {
        // Given
        let enumCase = EnumCaseDeclSyntax(elementsBuilder:  {
            EnumCaseElementSyntax(
                leadingTrivia: .space,
                name: .identifier("hello"),
                rawValue: InitializerClauseSyntax(
                    equal: .equalToken(leadingTrivia: .space, trailingTrivia: .space),
                    value: StringLiteralExprSyntax(content: "world")))
        })
        
        // When
        let identifier = sut.extract(from: enumCase)
        
        // Then
        XCTAssertEqual(identifier, "hello")
    }
}
