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
        let sourceData = try Data(contentsOf: srcURL)
        let targetData = try? Data(contentsOf: dstURL)
        
        if sourceData != targetData {
            try? removeItem(at: dstURL)
            try moveItem(at: srcURL, to: dstURL)
        }
    }
}
