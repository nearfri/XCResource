import Foundation

class XcodeIssueReporter: IssueReporter {
    func report(_ issue: Issue) {
        print(makeReport(issue: issue))
    }
    
    private func makeReport(issue: Issue) -> String {
        let path = issue.fileURL.path
        let line = issue.lineNumber
        let column = issue.columnNumber
        
        let message: String = {
            if issue.isAtEndOfLine {
                return "\(issue.content); error occurred at the end of the line"
            }
            return issue.content
        }()
        
        return "\(path):\(line):\(column): error: \(message)"
    }
}
