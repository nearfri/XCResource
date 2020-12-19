import Foundation

class ActualPropertyListGenerator: PropertyListGenerator {
    func generate(from items: [LocalizationItem]) -> String {
        var result = ""
        
        for (index, item) in items.enumerated() {
            if let comment = item.comment {
                result.write("/* \(comment.addingBackslashEncoding()) */\n")
            }
            result.write("\"\(item.key)\" = \"\(item.value.addingBackslashEncoding())\";")
            
            let isLastItem = index + 1 == items.count
            result.write(isLastItem ? "" : "\n\n")
        }
        
        return result
    }
}
