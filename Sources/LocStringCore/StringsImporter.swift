import Foundation
import StrixParsers

public class StringsImporter: LocalizationItemImporter {
    public init() {}
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        let plistString = try String(contentsOf: url, encoding: .utf8)
        let plist = try ASCIIPlistParser().parse(plistString)
        
        guard case let .dictionary(entries) = plist else {
            throw StringsFileError.typeMismatch(expected: "dictionary", actual: plist)
        }
        
        return try entries.map { entry in
            guard case let .string(value) = entry.value else {
                throw StringsFileError.typeMismatch(expected: "string", actual: entry.value)
            }
            return LocalizationItem(key: entry.key, value: value, comment: entry.comment)
        }
    }
}

public enum StringsFileError: Error {
    case typeMismatch(expected: String, actual: ASCIIPlist)
}
