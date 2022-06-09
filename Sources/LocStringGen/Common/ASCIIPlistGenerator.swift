import Foundation
import XCResourceUtil

class ASCIIPlistGenerator: PropertyListGenerator {
    func generate(from items: [LocalizationItem]) -> String {
        var result = ""
        
        for (index, item) in items.enumerated() {
            if let comment = item.comment {
                result += "/* \(comment.replacingOccurrences(of: "*/", with: " ")) */\n"
            }
            result += "\"\(item.key)\" = \"\(item.value.addingBackslashEncoding())\";"
            
            let isLastItem = index + 1 == items.count
            result += isLastItem ? "" : "\n\n"
        }
        
        return result
    }
}
