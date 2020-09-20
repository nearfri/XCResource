import Foundation

extension String {
    func appendingPathComponent(_ str: String) -> String {
        if isEmpty { return str }
        if str.isEmpty { return self }
        
        if hasSuffix("/") || str.hasPrefix("/") {
            return self + str
        }
        return self + "/" + str
    }
}
