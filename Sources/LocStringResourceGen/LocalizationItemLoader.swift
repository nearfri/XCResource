import Foundation

protocol LocalizationItemLoader: AnyObject {
    func load(source: String) throws -> [LocalizationItem]
}
