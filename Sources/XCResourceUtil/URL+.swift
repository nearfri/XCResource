import Foundation

extension URL {
    public init(
        filePath path: String,
        expandingTilde: Bool,
        directoryHint: URL.DirectoryHint = .inferFromPath,
        relativeTo base: URL? = nil
    ) {
        if expandingTilde {
            let expandedPath = (path as NSString).expandingTildeInPath
            self.init(filePath: expandedPath, directoryHint: directoryHint, relativeTo: base)
        } else {
            self.init(filePath: path, directoryHint: directoryHint, relativeTo: base)
        }
    }
}
