import Foundation

extension URL {
    @available(macOS, deprecated: 26.0)
    public init(
        filePath path: String,
        expandingTilde: Bool,
        directoryHint: URL.DirectoryHint = .inferFromPath,
        relativeTo base: URL? = nil
    ) {
        if #available(macOS 26, *) {
            self.init(filePath: path, directoryHint: directoryHint, relativeTo: base)
        } else {
            if expandingTilde {
                let expandedPath = (path as NSString).expandingTildeInPath
                self.init(filePath: expandedPath, directoryHint: directoryHint, relativeTo: base)
            } else {
                self.init(filePath: path, directoryHint: directoryHint, relativeTo: base)
            }
        }
    }
}
