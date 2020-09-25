import Foundation

extension String {
    public func appendingPathComponent(_ str: String) -> String {
        if isEmpty { return str }
        if str.isEmpty { return self }
        
        switch (hasSuffix("/"), str.hasPrefix("/")) {
        case (false, false):
            return self + "/" + str
        case (true, false), (false, true):
            return self + str
        case (true, true):
            return self + str.dropFirst()
        }
    }
    
    public var deletingLastPathComponent: String {
        let truncatedPath = self        // /tmp/scratch.tiff/
            .reversed()                 // /ffit.hctarcs/pmt/
            .drop(while: { $0 == "/" }) // ffit.hctarcs/pmt/
            .drop(while: { $0 != "/" }) // /pmt/
            .dropFirst()                // pmt/
            .reversed()                 // /tmp
        
        if truncatedPath.isEmpty && hasPrefix("/") {
            return "/"
        }
        return String(truncatedPath)
    }
}
