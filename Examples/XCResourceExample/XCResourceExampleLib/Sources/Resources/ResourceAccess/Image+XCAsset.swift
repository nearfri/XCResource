import Foundation
import SwiftUI

public extension Image {
    init(key: ImageKey) {
        self.init(key.name, bundle: key.bundle)
    }
    
    init(key: ImageKey, label: Text) {
        self.init(key.name, bundle: key.bundle, label: label)
    }
}
