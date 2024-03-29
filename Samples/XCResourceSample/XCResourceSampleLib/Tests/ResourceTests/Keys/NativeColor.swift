import Foundation

#if os(macOS)

import AppKit

typealias NativeColor = NSColor

extension NSColor {
    convenience init?(named name: String, in bundle: Bundle) {
        self.init(named: name, bundle: bundle)
    }
}

#else

import UIKit

typealias NativeColor = UIColor

extension UIColor {
    convenience init?(named name: String, in bundle: Bundle) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}

#endif
