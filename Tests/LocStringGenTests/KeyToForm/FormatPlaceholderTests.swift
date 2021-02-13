import XCTest
@testable import LocStringGen

final class FormatPlaceholderTests: XCTestCase {
    func test_toFunctionParameters_withoutLabel() throws {
        // Given
        // "%d:%.*d"
        let placeholders: [FormatPlaceholder] = [
            FormatPlaceholder(valueType: Int32.self),
            FormatPlaceholder(dynamicPrecision: .init(index: nil), valueType: Int32.self),
        ]
        
        // When
        let parameters = try placeholders.toFunctionParameters()
        
        // Then
        XCTAssertEqual(parameters, [
            FunctionParameter(externalName: "", localName: "", type: Int32.self),
            FunctionParameter(externalName: "", localName: "", type: Int.self),
            FunctionParameter(externalName: "", localName: "", type: Int32.self),
        ])
    }
    
    func test_toFunctionParameters_withLabel() throws {
        // Given
        // "%d{hours}:%.*d{precision p1, minutes}"
        let placeholders: [FormatPlaceholder] = [
            FormatPlaceholder(valueType: Int32.self,
                              labels: ["hours"]),
            FormatPlaceholder(dynamicPrecision: .init(index: nil),
                              valueType: Int32.self,
                              labels: ["precision p1", "minutes"]),
        ]
        
        // When
        let parameters = try placeholders.toFunctionParameters()
        
        // Then
        XCTAssertEqual(parameters, [
            FunctionParameter(externalName: "", localName: "hours", type: Int32.self),
            FunctionParameter(externalName: "precision", localName: "p1", type: Int.self),
            FunctionParameter(externalName: "", localName: "minutes", type: Int32.self),
        ])
    }
    
    func test_toFunctionParameters_withIndexWithoutLabel() throws {
        // Given
        // "%1$d:%2$.*3$d:%4$.*3$d"
        let placeholders: [FormatPlaceholder] = [
            FormatPlaceholder(index: 1, valueType: Int32.self),
            FormatPlaceholder(index: 2, dynamicPrecision: .init(index: 3), valueType: Int32.self),
            FormatPlaceholder(index: 4, dynamicPrecision: .init(index: 3), valueType: Int32.self),
        ]
        
        // When
        let parameters = try placeholders.toFunctionParameters()
        
        // Then
        XCTAssertEqual(parameters, [
            FunctionParameter(externalName: "", localName: "", type: Int32.self),
            FunctionParameter(externalName: "", localName: "", type: Int32.self),
            FunctionParameter(externalName: "", localName: "", type: Int.self),
            FunctionParameter(externalName: "", localName: "", type: Int32.self),
        ])
    }
    
    func test_toFunctionParameters_withIndexWithLabel() throws {
        // Given
        // "%1$d{hours}:%2$.*3$d{precision,minutes}:%4$.*3$d{precision,seconds}"
        let placeholders: [FormatPlaceholder] = [
            FormatPlaceholder(index: 1,
                              valueType: Int32.self,
                              labels: ["hours"]),
            FormatPlaceholder(index: 2,
                              dynamicPrecision: .init(index: 3),
                              valueType: Int32.self,
                              labels: ["precision", "minutes"]),
            FormatPlaceholder(index: 4,
                              dynamicPrecision: .init(index: 3),
                              valueType: Int32.self,
                              labels: ["precision", "seconds"]),
        ]
        
        // When
        let parameters = try placeholders.toFunctionParameters()
        
        // Then
        XCTAssertEqual(parameters, [
            FunctionParameter(externalName: "", localName: "hours", type: Int32.self),
            FunctionParameter(externalName: "", localName: "minutes", type: Int32.self),
            FunctionParameter(externalName: "", localName: "precision", type: Int.self),
            FunctionParameter(externalName: "", localName: "seconds", type: Int32.self),
        ])
    }
    
    func test_toFunctionParameters_withIndexWithLabel_order() throws {
        // Given
        // "%1$d{hours}:%2$.*4$d{precision,minutes}:%3$.*4$d{precision,seconds}"
        let placeholders: [FormatPlaceholder] = [
            FormatPlaceholder(index: 1,
                              valueType: Int32.self,
                              labels: ["hours"]),
            FormatPlaceholder(index: 2,
                              dynamicPrecision: .init(index: 4),
                              valueType: Int32.self,
                              labels: ["precision", "minutes"]),
            FormatPlaceholder(index: 3,
                              dynamicPrecision: .init(index: 4),
                              valueType: Int32.self,
                              labels: ["precision", "seconds"]),
        ]
        
        // When
        let parameters = try placeholders.toFunctionParameters()
        
        // Then
        XCTAssertEqual(parameters, [
            FunctionParameter(externalName: "", localName: "hours", type: Int32.self),
            FunctionParameter(externalName: "", localName: "minutes", type: Int32.self),
            FunctionParameter(externalName: "", localName: "seconds", type: Int32.self),
            FunctionParameter(externalName: "", localName: "precision", type: Int.self),
        ])
    }
    
    func test_toFunctionParameters_mixIndexedAndNonIndexed_throwError() {
        // Given
        // "%1$d:%d"
        let placeholders: [FormatPlaceholder] = [
            FormatPlaceholder(index: 1, valueType: Int32.self),
            FormatPlaceholder(valueType: Int32.self),
        ]
        
        // When, Then
        XCTAssertThrowsError(try placeholders.toFunctionParameters())
    }
    
    func test_toFunctionParameters_missingIndices_throwError() {
        // Given
        // "%1$d:%3d"
        let placeholders: [FormatPlaceholder] = [
            FormatPlaceholder(index: 1, valueType: Int32.self),
            FormatPlaceholder(index: 3, valueType: Int32.self),
        ]
        
        // When, Then
        XCTAssertThrowsError(try placeholders.toFunctionParameters())
    }
}
