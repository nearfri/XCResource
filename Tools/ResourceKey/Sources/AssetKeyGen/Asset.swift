import Foundation

struct Asset {
    var name: String    // icon.check
    var path: String    // Common/icon.check.imageset
    
    var key: String {   // icon_check
        return name
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .map({ $0.prefix(1).lowercased() + $0.dropFirst(1) })
            .joined(separator: "_")
    }
}
