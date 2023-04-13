import Foundation

public protocol StringsdictImporter: AnyObject {
    func `import`(from plist: Plist) throws -> [LocalizationItem]
}
