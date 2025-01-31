import Foundation

extension FileManager {
    public func fileExists(at url: URL) -> Bool {
        return fileExists(atPath: url.path(percentEncoded: false))
    }
    
    public func makeTemporaryItemURL() -> URL {
        return temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }
    
    public func compareAndReplaceItem(at originalItemPath: String,
                                      withItemAt newItemURL: URL) throws {
        let originalItemURL = URL(filePath: originalItemPath, expandingTilde: true)
        try compareAndReplaceItem(at: originalItemURL, withItemAt: newItemURL)
    }
    
    public func compareAndReplaceItem(at originalItemURL: URL, withItemAt newItemURL: URL) throws {
        if contentsEqual(atPath: originalItemURL.path, andPath: newItemURL.path) {
            try removeItem(at: newItemURL)
        } else {
            try replaceItem(at: originalItemURL,
                            withItemAt: newItemURL,
                            backupItemName: nil,
                            options: [],
                            resultingItemURL: nil)
        }
    }
}
