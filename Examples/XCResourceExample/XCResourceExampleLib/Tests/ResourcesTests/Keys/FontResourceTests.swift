import XCTest
@testable import Resources

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
typealias NativeFont = UIFont
#elseif os(macOS)
import AppKit.NSFont
typealias NativeFont = NSFont
#endif

final class FontResourceTests: XCTestCase {
    func test_fontsExist() throws {
        let registry = FontRegistry.shared
        
        registry.registerAllFonts()
        
        for resource in FontResource.all {
            XCTAssertNotNil(NativeFont(name: resource.fontName, size: 10),
                            "\(resource.fontName) loading failed")
        }
    }
}
