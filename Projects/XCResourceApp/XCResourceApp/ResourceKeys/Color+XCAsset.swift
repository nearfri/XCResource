import Foundation
import UIKit
import SwiftUI

extension UIColor {
    convenience init(key: ColorKey) {
        self.init(named: key.rawValue, in: .module, compatibleWith: nil)!
    }
}

extension Color {
    init(key: ColorKey) {
        self.init(key.rawValue, bundle: .module)
    }
}
