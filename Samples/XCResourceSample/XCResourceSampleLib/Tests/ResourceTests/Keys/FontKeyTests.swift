import XCTest
@testable import Resource

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
typealias NativeFont = UIFont
#elseif os(macOS)
import AppKit.NSFont
typealias NativeFont = NSFont
#endif

final class FontKeyTests: XCTestCase {
    func test_fontsExist() throws {
        let registry = FontRegistry.shared
        
        registry.registerAllFonts()
        
        for fontKey in FontKey.allKeys {
            XCTAssertNotNil(NativeFont(name: fontKey.fontName, size: 10),
                            "\(fontKey.fontName) loading failed")
        }
    }
}
