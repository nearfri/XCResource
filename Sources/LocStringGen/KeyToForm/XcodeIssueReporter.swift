import Foundation

class XcodeIssueReporter: IssueReporter {
    func report(_ issue: Issue) {
        print(makeReport(issue: issue))
    }
    
    private func makeReport(issue: Issue) -> String {
        let path = issue.fileURL.path
        let line = issue.lineNumber
        let column = issue.columnNumber
        let content = issue.content
        
        return "\(path):\(line):\(column): error: \(content)"
    }
}
