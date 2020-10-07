import Foundation

extension FileManager {
    public func makeTemporaryFileURL() -> URL {
        return temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }
    
    public func compareAndMoveFile(from srcURL: URL, to dstPath: String) throws {
        let dstURL = URL(fileURLWithExpandingTildeInPath: dstPath)
        try compareAndMoveFile(from: srcURL, to: dstURL)
    }
    
    public func compareAndMoveFile(from srcURL: URL, to dstURL: URL) throws {
        if !contentsEqual(atPath: srcURL.path, andPath: dstURL.path) {
            try? removeItem(at: dstURL)
            try moveItem(at: srcURL, to: dstURL)
        }
    }
}
