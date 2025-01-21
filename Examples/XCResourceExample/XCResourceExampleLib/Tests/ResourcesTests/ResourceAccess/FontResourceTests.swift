import Testing
@testable import Resources

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
typealias NativeFont = UIFont
#elseif os(macOS)
import AppKit.NSFont
typealias NativeFont = NSFont
#endif

struct FontResourceTests {
    @Test func fontsExist() throws {
        let registry = FontRegistry.shared
        
        registry.registerAllFonts()
        
        for resource in FontResource.all {
            #expect(NativeFont(name: resource.fontName, size: 10) != nil,
                    "\(resource.fontName) loading failed")
        }
    }
}
