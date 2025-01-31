import Foundation
import XCResourceUtil

struct FileItem: Hashable, Sendable {
    let url: URL
    
    var namespace: String {
        return url.lastPathComponent.toTypeIdentifier()
    }
    
    var identifier: String {
        return url.deletingPathExtension().lastPathComponent.toIdentifier()
    }
}
