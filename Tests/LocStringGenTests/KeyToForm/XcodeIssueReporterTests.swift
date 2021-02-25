import XCTest
@testable import LocStringGen

final class XcodeIssueReporterTests: XCTestCase {
    func test_report() {
        if ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] != nil {
            return
        }
        
        // Given
        let sut = XcodeIssueReporter()
        let issue = Issue(fileURL: URL(fileURLWithPath: "/code.swift"),
                          lineNumber: 53,
                          columnNumber: 21,
                          content: "Expecting: any character in [diuf@]")
        
        let stdOutSniffer = StandardOutputSniffer()
        stdOutSniffer.begin()
        
        // When
        sut.report(issue)
        stdOutSniffer.end()
        
        // Then
        XCTAssertEqual(stdOutSniffer.stringFromData(),
                       "/code.swift:53:21: error: Expecting: any character in [diuf@]\n")
    }
}
