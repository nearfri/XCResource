import Foundation
import XCResourceUtil

struct Font: Equatable {
    var fontName: String
    var familyName: String
    var style: String
    var relativePath: String
    
    var key: String {
        func normalize(_ string: String) -> String {
            return string
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .joined()
                .camelCased()
        }
        
        if style.isEmpty {
            return normalize(familyName)
        }
        return normalize(familyName) + "_" + normalize(style)
    }
}
