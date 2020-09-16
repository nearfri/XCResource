import Foundation
import SwiftUI

extension String {
    init(key: StringKey) {
        self = NSLocalizedString(key.rawValue, bundle: .module, comment: "")
    }
    
    init(formatKey: StringKey, _ arguments: CVarArg...) {
        self.init(formatKey: formatKey, arguments: arguments)
    }
    
    init(formatKey: StringKey, arguments: [CVarArg]) {
        let format = NSLocalizedString(formatKey.rawValue, bundle: .module, comment: "")
        self.init(format: format, arguments: arguments)
    }
}

extension Text {
    init(key: StringKey) {
        self.init(LocalizedStringKey(key.rawValue), bundle: .module)
    }
}
