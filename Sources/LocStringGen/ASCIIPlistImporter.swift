import Foundation
import StrixParsers

class ASCIIPlistImporter: LocalizationItemImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        let plistDocument = try String(contentsOf: url)
        let plist = try ASCIIPlistParser().parse(plistDocument)
        guard case let .dictionary(entries) = plist else {
            throw ASCIIPlistError.invalidPlistType(expected: "dictionary", actual: plist)
        }
        
        return try entries.map { entry in
            guard case let .string(value) = entry.value else {
                throw ASCIIPlistError.invalidPlistType(expected: "string", actual: entry.value)
            }
            return LocalizationItem(comment: entry.comment, key: entry.key, value: value)
        }
    }
}

enum ASCIIPlistError: Error {
    case invalidPlistType(expected: String, actual: ASCIIPlist)
}
