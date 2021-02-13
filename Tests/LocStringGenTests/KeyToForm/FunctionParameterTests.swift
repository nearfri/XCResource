import XCTest
@testable import LocStringGen

final class FunctionParameterTests: XCTestCase {
    func test_sourceCodeRepresentation_bothNamesExist_useBoth() {
        // Given
        let sut = FunctionParameter(externalName: "at", localName: "index", type: Int.self)
        
        // When
        let sourceCode = sut.sourceCodeRepresentation(alternativeName: "param1")
        
        // Then
        XCTAssertEqual(sourceCode, "at index: Int")
    }
    
    func test_sourceCodeRepresentation_bothNameAreEqual_useOne() {
        // Given
        let sut = FunctionParameter(externalName: "index", localName: "index", type: Int.self)
        
        // When
        let sourceCode = sut.sourceCodeRepresentation(alternativeName: "param1")
        
        // Then
        XCTAssertEqual(sourceCode, "index: Int")
    }
    
    func test_sourceCodeRepresentation_externalNameNotExist_useLocalName() {
        // Given
        let sut = FunctionParameter(externalName: "", localName: "index", type: Int.self)
        
        // When
        let sourceCode = sut.sourceCodeRepresentation(alternativeName: "param1")
        
        // Then
        XCTAssertEqual(sourceCode, "index: Int")
    }
    
    func test_sourceCodeRepresentation_bothNamesNotExist_useAlternativeName() {
        // Given
        let sut = FunctionParameter(externalName: "", localName: "", type: Int.self)
        
        // When
        let sourceCode = sut.sourceCodeRepresentation(alternativeName: "param1")
        
        // Then
        XCTAssertEqual(sourceCode, "param1: Int")
    }
}
