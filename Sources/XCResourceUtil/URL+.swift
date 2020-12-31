import Foundation

extension URL {
    public init(fileURLWithExpandingTildeInPath path: String) {
        let expandedPath = (path as NSString).expandingTildeInPath
        self.init(fileURLWithPath: expandedPath)
    }
    
    public func appendingPathComponents(language: String, tableName: String) -> URL {
        return appendingPathComponent("\(language).lproj/\(tableName).strings")
    }
}
