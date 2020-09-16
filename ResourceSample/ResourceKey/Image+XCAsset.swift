import Foundation
import UIKit
import SwiftUI

extension UIImage {
    convenience init(key: ImageKey) {
        #if DEBUG
        if UIImage(named: key.rawValue, in: .module, compatibleWith: nil) == nil {
            preconditionFailure("UIImage \(key.rawValue) not found.")
        }
        #endif
        
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
