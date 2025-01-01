import Foundation
import SwiftUI

public extension Image {
    init(key: ImageKey) {
        self.init(key.rawValue, bundle: .module)
    }
    
    init(key: ImageKey, label: Text) {
        self.init(key.rawValue, bundle: .module, label: label)
    }
}
