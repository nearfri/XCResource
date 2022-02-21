import Foundation
import XCResourceUtil

struct Asset {
    var name: String    // icon.check
    var path: String    // Common/icon.check.imageset
    var type: AssetType
    
    var key: String {   // icon_check
        return name
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .map({ $0.camelCased() })
            .joined(separator: "_")
    }
}
