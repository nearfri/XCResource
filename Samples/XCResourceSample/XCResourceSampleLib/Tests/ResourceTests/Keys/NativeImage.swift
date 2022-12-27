import Foundation

#if os(macOS)

import AppKit

typealias NativeImage = NSImage

extension NSImage {
    convenience init?(named name: String, in bundle: Bundle) {
        let fullName = "\(bundle.bundleIdentifier ?? bundle.bundlePath)/\(name)"
        
        if NSImage(named: fullName) == nil {
            guard let image = bundle.image(forResource: name) else { return nil }
            image.setName(fullName)
        }
        
        self.init(named: fullName)
    }
}

#else

import UIKit

typealias NativeImage = UIImage

extension UIImage {
    convenience init?(named name: String, in bundle: Bundle) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}

#endif
