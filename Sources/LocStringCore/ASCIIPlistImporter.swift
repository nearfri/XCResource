import Foundation
import StrixParsers

public class ASCIIPlistImporter: LocalizationItemImporter {
    public init() {}
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        let plistString = try String(contentsOf: url)
        let plist = try ASCIIPlistParser().parse(plistString)
        guard case let .dictionary(entries) = plist else {
            throw ASCIIPlistError.invalidPlistType(expected: "dictionary", actual: plist)
        }
        
        return try entries.map { entry in
            guard case let .string(value) = entry.value else {
                throw ASCIIPlistError.invalidPlistType(expected: "string", actual: entry.value)
            }
            return LocalizationItem(key: entry.key, value: value, comment: entry.comment)
        }
    }
}

public enum ASCIIPlistError: Error {
    case invalidPlistType(expected: String, actual: ASCIIPlist)
}
