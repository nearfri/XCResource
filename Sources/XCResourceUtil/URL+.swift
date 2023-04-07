import Foundation

public enum StringTableType: String {
    case strings
    case stringsdict
}

extension URL {
    public init(fileURLWithExpandingTildeInPath path: String) {
        let expandedPath = (path as NSString).expandingTildeInPath
        self.init(fileURLWithPath: expandedPath)
    }
    
    public func appendingPathComponents(
        language: String,
        tableName: String,
        tableType: StringTableType = .strings
    ) -> URL {
        return appendingPathComponent("\(language).lproj/\(tableName).\(tableType.rawValue)")
    }
}
