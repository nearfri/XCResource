import Foundation

protocol LocalizationItemImporter: AnyObject {
    func `import`(at url: URL) throws -> [LocalizationItem]
}
