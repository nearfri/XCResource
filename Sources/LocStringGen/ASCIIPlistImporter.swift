import Foundation

class ASCIIPlistImporter: LocalizationItemImporter {
    func `import`(at url: URL) throws -> [LocalizationItem] {
        let plistData = try Data(contentsOf: url)
        let plist = try PropertyListDecoder().decode([String: String].self, from: plistData)
        
        return plist.map { key, value in
            LocalizationItem(comment: nil, key: key, value: value)
        }
    }
}
