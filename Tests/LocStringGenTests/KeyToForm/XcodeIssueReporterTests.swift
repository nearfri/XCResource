import XCTest
@testable import LocStringGen

final class XcodeIssueReporterTests: XCTestCase {
    func test_report() {
        // Given
        let sut = XcodeIssueReporter()
        let issue = Issue(fileURL: URL(fileURLWithPath: "/code.swift"),
                          lineNumber: 53,
                          columnNumber: 21,
                          isAtEndOfLine: false,
                          content: "Expecting: any character in [diuf@]")
        
        let stdOutSniffer = StandardOutputSniffer()
        stdOutSniffer.start()
        
        // When
        sut.report(issue)
        
        // Then
        stdOutSniffer.stop()
        XCTAssertEqual(stdOutSniffer.stringFromData(),
                       "/code.swift:53:21: error: Expecting: any character in [diuf@]\n")
    }
    
    func test_report_atEndOfLine() {
        // Given
        let sut = XcodeIssueReporter()
        let issue = Issue(fileURL: URL(fileURLWithPath: "/code.swift"),
                          lineNumber: 53,
                          columnNumber: 21,
                          isAtEndOfLine: true,
                          content: "Expecting: any character in [diuf@]")
        
        let stdOutSniffer = StandardOutputSniffer()
        stdOutSniffer.start()
        
        // When
        sut.report(issue)
        
        // Then
        stdOutSniffer.stop()
        XCTAssertEqual(stdOutSniffer.stringFromData(),
                       "/code.swift:53:21: error: Expecting: any character in [diuf@]"
                       + "; error occurred at the end of the line\n")
    }
}
