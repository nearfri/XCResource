import Foundation
import System
import XCResourceUtil

struct Font: Equatable, SettableByKeyPath {
    var fontName: String
    var familyName: String
    var style: String
    var relativePath: String
    
    var key: String {
        if style.isEmpty {
            return familyName.toIdentifier()
        }
        return familyName.toIdentifier() + style.toTypeIdentifier()
    }
}
