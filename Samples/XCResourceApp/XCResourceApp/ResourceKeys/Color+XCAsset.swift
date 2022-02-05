import Foundation
import UIKit
import SwiftUI

extension UIColor {
    static func named(_ key: ColorKey) -> UIColor {
        return UIColor(named: key.rawValue, in: .module, compatibleWith: nil)!
    }
}

extension Color {
    init(key: ColorKey) {
        self.init(key.rawValue, bundle: .module)
    }
}
