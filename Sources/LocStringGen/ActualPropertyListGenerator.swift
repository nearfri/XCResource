import Foundation
import StrixParsers

class ActualPropertyListGenerator: PropertyListGenerator {
    func generate(from items: [LocalizationItem]) -> String {
        let plistEntries = items.map({
            ASCIIPlist.DictionaryEntry(comment: $0.comment, key: $0.key, value: .string($0.value))
        })
        return ASCIIPlist.dictionary(plistEntries).description
    }
}
