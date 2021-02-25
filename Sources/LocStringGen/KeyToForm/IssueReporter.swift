import Foundation
import Strix

struct IssueReportError: LocalizedError {
    var text: String
    var positionInText: String.Index?
    var failureDescription: String
    
    var errorDescription: String? {
        guard let positionInText = positionInText else {
            return """
                \(failureDescription)
                    Text: \(text)
                """
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .ordinal
        let column = text.distance(from: text.startIndex, to: positionInText) + 1
        let columnAsString = formatter.string(from: NSNumber(value: column)) ?? "\(column)th"
        
        return """
            \(failureDescription)
                Text: \(text)
                Position: \(columnAsString) character
            """
    }
}

struct Issue {
    var fileURL: URL
    var lineNumber: Int
    var columnNumber: Int
    var content: String
    
    init?(fileURL: URL, error: IssueReportError) {
        self.fileURL = fileURL
        self.content = error.failureDescription
        
        guard let errorPosition = Issue.calculateErrorPosition(fileURL: fileURL, error: error)
        else { return nil }
        
        self.lineNumber = errorPosition.lineNumber
        self.columnNumber = errorPosition.columnNumber
    }
    
    private static func calculateErrorPosition(
        fileURL: URL,
        error: IssueReportError
    ) -> (lineNumber: Int, columnNumber: Int)? {
        guard let document = try? String(contentsOf: fileURL),
              let textRange = document.range(of: error.text)
        else { return nil }
        
        let positionInText = error.positionInText ?? error.text.startIndex
        let distance = error.text.distance(from: error.text.startIndex, to: positionInText)
        let errorIndex = document.index(textRange.lowerBound, offsetBy: distance)
        let errorPosition = TextPosition(string: document, index: errorIndex)
        
        return (lineNumber: errorPosition.line, columnNumber: errorPosition.column)
    }
}

protocol IssueReporter: AnyObject {
    func report(_ issue: Issue)
}
