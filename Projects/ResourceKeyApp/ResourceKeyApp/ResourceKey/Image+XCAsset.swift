import Foundation
import UIKit
import SwiftUI

extension UIImage {
    convenience init(key: ImageKey) {
        self.init(named: key.rawValue, in: .module, compatibleWith: nil)!
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
