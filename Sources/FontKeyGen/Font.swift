import Foundation
import System
import XCResourceUtil

struct Font: Equatable, Sendable, SettableByKeyPath {
    var fontName: String
    var familyName: String
    var style: String
    var relativePath: String
    
    func key(asLatin: Bool, strippingCombiningMarks: Bool) -> String {
        func refine(_ string: String) -> String {
            var result = string
            if asLatin {
                result = result.latinCased()
            }
            if strippingCombiningMarks {
                result = result.applyingTransform(.stripCombiningMarks, reverse: false) ?? result
            }
            return result
        }
        
        if style.isEmpty {
            return refine(familyName).toIdentifier()
        }
        return refine(familyName).toIdentifier() + refine(style).toTypeIdentifier()
    }
}
