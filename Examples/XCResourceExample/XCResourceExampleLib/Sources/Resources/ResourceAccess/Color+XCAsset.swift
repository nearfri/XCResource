import Foundation
import SwiftUI

public extension Color {
    init(key: ColorKey) {
        self.init(key.name, bundle: key.bundle)
    }
}
