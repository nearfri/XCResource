import XCTest
@testable import LocStringFormGen

final class ActualFormatPlaceholderImporterTests: XCTestCase {
    private let sut: DefaultFormatPlaceholderImporter = .init()
    
    func test_import_withoutLabel() throws {
        // Given
        let comment = "영상은 최대 %ld분, %fGB까지 가능합니다.\\n길이를 수정하세요."
        
        // When
        let placeholders = try sut.import(from: comment)
        
        // Then
        XCTAssertEqual(placeholders, [
            FormatPlaceholder(valueType: Int.self),
            FormatPlaceholder(valueType: Double.self),
        ])
    }
    
    func test_import_withLabel() throws {
        // Given
        let comment = "영상은 최대 %{duration}ld분, %{size}fGB까지 가능합니다.\\n길이를 수정하세요."
        
        // When
        let placeholders = try sut.import(from: comment)
        
        // Then
        XCTAssertEqual(placeholders, [
            FormatPlaceholder(valueType: Int.self, labels: ["duration"]),
            FormatPlaceholder(valueType: Double.self, labels: ["size"]),
        ])
    }
    
    func test_import_withIndexWithoutLabel() throws {
        // Given
        let comment = "%1$ld:%2$.*3$ld:%4$.*3$ld"
        
        // When
        let placeholders = try sut.import(from: comment)
        
        // Then
        XCTAssertEqual(placeholders, [
            FormatPlaceholder(index: 1, valueType: Int.self),
            FormatPlaceholder(index: 2, dynamicPrecision: .init(index: 3), valueType: Int.self),
            FormatPlaceholder(index: 4, dynamicPrecision: .init(index: 3), valueType: Int.self),
        ])
    }
    
    func test_import_withIndexWithLabel() throws {
        // Given
        let comment = "%{hours}1$ld:%{precision p1,minutes}2$.*3$ld:%{precision p2,seconds}4$.*3$ld"
        
        // When
        let placeholders = try sut.import(from: comment)
        
        // Then
        XCTAssertEqual(placeholders, [
            FormatPlaceholder(index: 1,
                              valueType: Int.self,
                              labels: ["hours"]),
            FormatPlaceholder(index: 2,
                              dynamicPrecision: .init(index: 3),
                              valueType: Int.self,
                              labels: ["precision p1", "minutes"]),
            FormatPlaceholder(index: 4,
                              dynamicPrecision: .init(index: 3),
                              valueType: Int.self,
                              labels: ["precision p2", "seconds"]),
        ])
    }
    
    func test_import_variableName() throws {
        // Given
        let comment = "My dog %@ ate %#@carrotsCount@ and %#@applesCount@ today!"
        
        // When
        let placeholders = try sut.import(from: comment)
        
        // Then
        XCTAssertEqual(placeholders, [
            FormatPlaceholder(valueType: String.self, labels: []),
            FormatPlaceholder(valueType: Int.self, labels: ["carrotsCount"]),
            FormatPlaceholder(valueType: Int.self, labels: ["applesCount"]),
        ])
    }
}
