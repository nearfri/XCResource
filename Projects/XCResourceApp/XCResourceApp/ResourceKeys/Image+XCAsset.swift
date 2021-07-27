import Foundation
import UIKit
import SwiftUI

extension UIImage {
    static func named(_ key: ImageKey) -> UIImage {
        return UIImage(named: key.rawValue, in: .module, compatibleWith: nil)!
    }
}

extension Image {
    init(key: ImageKey) {
        self.init(key.rawValue, bundle: .module)
    }
    
    init(key: ImageKey, label: Text) {
        self.init(key.rawValue, bundle: .module, label: label)
    }
}
