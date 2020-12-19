import Foundation

extension String {
    public func addingBackslashEncoding() -> String {
        let backslashMap: [Character: String] = [
            "\"": #"\""#, "\n": #"\n"#, "\r": #"\r"#, "\t": #"\t"#,
            "\u{0008}": #"\b"#, "\u{000C}": #"\f"#
        ]
        
        return reduce(into: "") { result, char in
            if let mapped = backslashMap[char] {
                result += mapped
            } else {
                result.append(char)
            }
        }
    }
    
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
