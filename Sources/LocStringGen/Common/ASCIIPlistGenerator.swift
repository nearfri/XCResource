import Foundation
import XCResourceUtil

class ASCIIPlistGenerator: PropertyListGenerator {
    func generate(from items: [LocalizationItem]) -> String {
        var result = ""
        
        for (index, item) in items.enumerated() {
            let comment = item.comment ?? ""
            
            if !comment.isEmpty {
                result += "/* \(comment.replacingOccurrences(of: "*/", with: " ")) */\n"
            }
            result += "\"\(item.key)\" = \"\(item.value.addingBackslashEncoding())\";"
            
            if index + 1 == items.count {
                break
            }
            
            let nextComment = items[index + 1].comment ?? ""
            result += comment.isEmpty && nextComment.isEmpty ? "\n" : "\n\n"
        }
        
        return result
    }
}
