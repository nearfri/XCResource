import Foundation

public enum Comment: Equatable {
    case line(String) // starting with '//'
    case block(String) // starting with '/*' and ending with '*/'
    case documentLine(String) // starting with '///'
    case documentBlock(String) // starting with '/**' and ending with '*/'
    
    public var text: String {
        switch self {
        case .line(let text):           return text
        case .block(let text):          return text
        case .documentLine(let text):   return text
        case .documentBlock(let text):  return text
        }
    }
    
    public var isForDeveloper: Bool {
        switch self {
        case .line, .block:
            return true
        case .documentLine, .documentBlock:
            return false
        }
    }
    
    public var isForDocument: Bool {
        switch self {
        case .line, .block:
            return false
        case .documentLine, .documentBlock:
            return true
        }
    }
}

extension Array where Element == Comment {
    public var joinedDocumentText: String? {
        let result = self
            .filter(\.isForDocument)
            .map(\.text)
            .map({ $0.replacingOccurrences(of: "\n", with: " ") })
            .reduce(into: "") { result, text in
                if !result.isEmpty && !result.hasSuffix("\\n") {
                    result += " "
                }
                result += text
            }
        
        return result.isEmpty ? nil : result
    }
}
