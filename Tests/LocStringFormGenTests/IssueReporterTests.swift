import XCTest
@testable import LocStringFormGen

final class IssueReportErrorTests: XCTestCase {
    func test_errorDescription() {
        // Given
        let text = "Hello %world"
        let positionInText = text.index(text.startIndex, offsetBy: 7)
        assert(text[positionInText] == "w")
        let failureDescription = "Expecting: any character in [diuf@]"
        let error = IssueReportError(text: text,
                                     positionInText: positionInText,
                                     failureDescription: failureDescription)
        
        let expectedErrorDescription = """
        \(failureDescription)
            Text: \(text)
            Position: 8th character
        """
        
        // When
        let actualErrorDescription = error.errorDescription
        
        // Then
        XCTAssertEqual(actualErrorDescription, expectedErrorDescription)
    }
}

final class IssueTests: XCTestCase {
    func test_initWithFileURLAndError() throws {
        // Given
        let fm = FileManager.default
        
        let document = """
        Blah blah
        Hello %world
        """
        let documentURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".txt")
        try document.write(to: documentURL, atomically: true, encoding: .utf8)
        defer { try? fm.removeItem(at: documentURL) }
        
        let text = "Hello %world"
        let positionInText = text.index(text.startIndex, offsetBy: 7)
        assert(text[positionInText] == "w")
        let failureDescription = "Expecting: any character in [diuf@]"
        let error = IssueReportError(text: text,
                                     positionInText: positionInText,
                                     failureDescription: failureDescription)
        
        // When
        let issue = Issue(fileURL: documentURL, error: error)
        
        // Then
        XCTAssertEqual(issue?.lineNumber, 2)
        XCTAssertEqual(issue?.columnNumber, 8)
    }
}
