import Foundation
import SwiftUI

public extension Font {
    static func custom(_ resource: FontResource, fixedSize: CGFloat) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: resource)
        
        return custom(resource.fontName, fixedSize: fixedSize)
    }
    
    static func custom(
        _ resource: FontResource,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle
    ) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: resource)
        
        return custom(resource.fontName, size: size, relativeTo: textStyle)
    }
    
    static func custom(_ resource: FontResource, size: CGFloat) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: resource)
        
        return custom(resource.fontName, size: size)
    }
}
