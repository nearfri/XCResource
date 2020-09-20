import Foundation

struct Asset {
    var name: String
    var relativePath: String
    
    var key: String {
        return name
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .map({ $0.prefix(1).lowercased() + $0.dropFirst(1) })
            .joined(separator: "_")
    }
}
