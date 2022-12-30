import XCTest
import Strix
@testable import LocSwiftCore

private extension Array where Element == FormatElement {
    func filterPlaceholder() -> Self {
        return filter {
            if case .placeholder = $0 { return true }
            return false
        }
    }
}

// MARK: - FormatElementsParserTests

final class FormatElementsParserTests: XCTestCase {
    private let sut: Parser<[FormatElement]> = Parser.formatElements
    
    // MARK: - Label parsing tests
    
    func test_run_simpleLabel() throws {
        // Given
        let comment = "%{name}@"
        
        // When
        let formatElements = try sut.run(comment)
        
        XCTAssertEqual(formatElements, [
            .placeholder(.init(conversion: .object), labels: ["name"]),
        ])
    }
    
    func test_run_labelWithExternalInternalNames() throws {
        // Given
        let comment = "%{with name}@"
        
        // When
        let formatElements = try sut.run(comment)
        
        XCTAssertEqual(formatElements, [
            .placeholder(.init(conversion: .object), labels: ["with name"]),
        ])
    }
    
    func test_run_labelWithWidthAndPrecision() throws {
        // Given
        let comment = "%{width, precision, number}*.*f"
        
        // When
        let formatElements = try sut.run(comment)
        
        XCTAssertEqual(formatElements, [
            .placeholder(.init(width: .dynamic(nil), precision: .dynamic(nil), conversion: .float),
                         labels: ["width", "precision", "number"]),
        ])
    }
    
    func test_run_labelStartsWithUnderline() throws {
        // Given
        let comment = "%{_name}@"
        
        // When
        let formatElements = try sut.run(comment)
        
        XCTAssertEqual(formatElements, [
            .placeholder(.init(conversion: .object), labels: ["_name"]),
        ])
    }
    
    func test_run_labelStartsWithNumber_fail() {
        // Given
        let comment = "%{5ab}@"
        
        // When
        XCTAssertThrowsError(try sut.run(comment)) { error in
            // Then
            let error = error as! Strix.RunError
            XCTAssertEqual(error.textPosition.column, 3)
        }
    }
    
    func test_run_labelContainsPunctuation_fail() {
        // Given
        let comment = "%{a-b}@"
        
        // When
        XCTAssertThrowsError(try sut.run(comment)) { error in
            // Then
            let error = error as! Strix.RunError
            XCTAssertEqual(error.textPosition.column, 4)
        }
    }
    
    func test_run_labelEndsWithoutBracket_fail() {
        // Given
        let comment = "%{ab@"
        
        // When
        XCTAssertThrowsError(try sut.run(comment)) { error in
            // Then
            let error = error as! Strix.RunError
            XCTAssertEqual(error.textPosition.column, 5)
        }
    }
    
    // MARK: - Comment parsing tests
    
    func test_run_character() throws {
        // Given
        let comment = "hi"
        
        // When
        let formatElements = try sut.run(comment)
        
        // Then
        XCTAssertEqual(formatElements, [
            .character("h"),
            .character("i"),
        ])
    }
    
    func test_run_withoutLabel() throws {
        // Given
        let comment = "영상은 최대 %ld분, %fGB까지 가능합니다.\\n길이를 수정하세요."
        
        // When
        let formatElements = try sut.run(comment).filterPlaceholder()
        
        // Then
        XCTAssertEqual(formatElements, [
            .placeholder(.init(length: .long, conversion: .decimal), labels: []),
            .placeholder(.init(conversion: .float), labels: []),
        ])
    }
    
    func test_run_withLabel() throws {
        // Given
        let comment = "영상은 최대 %{duration}ld분, %{size}fGB까지 가능합니다.\\n길이를 수정하세요."
        
        // When
        let formatElements = try sut.run(comment).filterPlaceholder()
        
        // Then
        XCTAssertEqual(formatElements, [
            .placeholder(.init(length: .long, conversion: .decimal), labels: ["duration"]),
            .placeholder(.init(conversion: .float), labels: ["size"]),
        ])
    }
    
    func test_run_withIndexWithoutLabel() throws {
        // Given
        let comment = "%1$ld:%2$.*3$ld:%4$.*3$ld"
        
        // When
        let formatElements = try sut.run(comment).filterPlaceholder()
        
        // Then
        XCTAssertEqual(formatElements, [
            .placeholder(.init(index: 1,
                               length: .long,
                               conversion: .decimal),
                         labels: []),
            .placeholder(.init(index: 2,
                               precision: .dynamic(3),
                               length: .long,
                               conversion: .decimal),
                         labels: []),
            .placeholder(.init(index: 4,
                               precision: .dynamic(3),
                               length: .long,
                               conversion: .decimal),
                         labels: []),
        ])
    }
    
    func test_run_withIndexWithLabel() throws {
        // Given
        let comment = "%{hours}1$ld:%{precision p1,minutes}2$.*3$ld:%{precision p2,seconds}4$.*3$ld"
        
        // When
        let formatElements = try sut.run(comment).filterPlaceholder()
        
        // Then
        XCTAssertEqual(formatElements, [
            .placeholder(.init(index: 1,
                               length: .long,
                               conversion: .decimal),
                         labels: ["hours"]),
            .placeholder(.init(index: 2,
                               precision: .dynamic(3),
                               length: .long,
                               conversion: .decimal),
                         labels: ["precision p1", "minutes"]),
            .placeholder(.init(index: 4,
                               precision: .dynamic(3),
                               length: .long,
                               conversion: .decimal),
                         labels: ["precision p2", "seconds"]),
        ])
    }
    
    func test_run_variableName() throws {
        // Given
        let comment = "My dog %@ ate %#@carrotsCount@ and %#@applesCount@ today!"
        
        // When
        let formatElements = try sut.run(comment).filterPlaceholder()
        
        // Then
        XCTAssertEqual(formatElements, [
            .placeholder(.init(conversion: .object), labels: []),
            .placeholder(.init(flags: [.hash], conversion: .object, variableName: "carrotsCount"),
                         labels: []),
            .placeholder(.init(flags: [.hash], conversion: .object, variableName: "applesCount"),
                         labels: []),
        ])
    }
}

// MARK: - FormatLabelRemovalParserTests

final class FormatLabelRemovalParserTests: XCTestCase {
    private let sut: Parser<String> = Parser.formatLabelRemoval
    
    func test_run_withoutLabel() throws {
        // Given
        let comment = "영상은 최대 %ld분, %fGB까지 가능합니다.\\n길이를 수정하세요."
        
        // When
        let string = try sut.run(comment)
        
        // Then
        XCTAssertEqual(string, comment)
    }
    
    func test_run_withLabel() throws {
        // Given
        let comment = "영상은 최대 %{duration}ld분, %{size}fGB까지 가능합니다.\\n길이를 수정하세요."
        
        // When
        let string = try sut.run(comment)
        
        // Then
        XCTAssertEqual(string, "영상은 최대 %ld분, %fGB까지 가능합니다.\\n길이를 수정하세요.")
    }
}

// MARK: - ContainsPluralVariablesParserTests

final class ContainsPluralVariablesParserTests: XCTestCase {
    private let sut: Parser<Bool> = Parser.containsPluralVariables
    
    func test_run_withoutPluralVariable() throws {
        // Given
        let comment = "My dog ate %@ today!"
        
        // When
        let contains = try sut.run(comment)
        
        // Then
        XCTAssertFalse(contains)
    }
    
    func test_run_withPluralVariable() throws {
        // Given
        let comment = "My dog ate %#@appleCount@ today!"
        
        // When
        let contains = try sut.run(comment)
        
        // Then
        XCTAssert(contains)
    }
}
