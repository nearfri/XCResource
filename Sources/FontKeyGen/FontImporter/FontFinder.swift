import Foundation
import UniformTypeIdentifiers

class FontFinder {
    func find(at url: URL) throws -> [String] {
        return try FileManager.default
            .subpathsOfDirectory(atPath: url.path)
            .filter({ isFontFile(at: url.appendingPathComponent($0)) })
            .sorted()
    }
    
    private func isFontFile(at url: URL) -> Bool {
        guard let resourceValues = try? url.resourceValues(forKeys: [.contentTypeKey]),
              let contentType = resourceValues.contentType
        else { return false }
        
        return contentType.isSubtype(of: .font)
    }
}
