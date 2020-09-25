import Foundation
import UIKit
import SwiftUI

extension UIColor {
    convenience init(key: ColorKey) {
        #if DEBUG
        if UIColor(named: key.rawValue, in: .module, compatibleWith: nil) == nil {
            preconditionFailure("UIColor \(key.rawValue) not found.")
        }
        #endif
        
        self.init(named: key.rawValue, in: .module, compatibleWith: nil)!
    }
}

extension Color {
    init(key: ColorKey) {
        self.init(key.rawValue, bundle: .module)
    }
}
