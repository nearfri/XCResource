import Foundation
import SwiftUI

public extension Font {
    static func custom(key: FontKey, fixedSize: CGFloat) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: key)
        
        return custom(key.fontName, fixedSize: fixedSize)
    }
    
    static func custom(key: FontKey, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: key)
        
        return custom(key.fontName, size: size, relativeTo: textStyle)
    }
    
    static func custom(key: FontKey, size: CGFloat) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: key)
        
        return custom(key.fontName, size: size)
    }
}
