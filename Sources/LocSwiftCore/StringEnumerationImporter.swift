import Foundation

public protocol StringEnumerationImporter: AnyObject {
    func `import`(at url: URL) throws -> Enumeration<String>
}
