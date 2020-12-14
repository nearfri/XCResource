import Foundation
import StrixParsers

class LocalizationTargetFetcher: LocalizationItemFetcher {
    func fetch(at url: URL) throws -> [LocalizationItem] {
        let plistDocument = try String(contentsOf: url)
        let plist = try ASCIIPlistParser().parse(plistDocument)
        guard case let .dictionary(entries) = plist else {
            throw TargetFetcherError.invalidPlistType(expected: "dictionary", actual: plist)
        }
        
        return try entries.map { entry in
            guard case let .string(value) = entry.value else {
                throw TargetFetcherError.invalidPlistType(expected: "string", actual: entry.value)
            }
            return LocalizationItem(comment: entry.comment, key: entry.key, value: value)
        }
    }
}

enum TargetFetcherError: Error {
    case invalidPlistType(expected: String, actual: ASCIIPlist)
}
