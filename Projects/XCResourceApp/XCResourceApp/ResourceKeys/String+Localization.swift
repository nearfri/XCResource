import Foundation
import SwiftUI

extension String {
    init(key: StringKey) {
        self = NSLocalizedString(key.rawValue, bundle: .module, comment: "")
    }
    
    init(template: StringTemplate) {
        let format = NSLocalizedString(template.key, bundle: .module, comment: "")
        self.init(format: format, locale: .current, arguments: template.arguments)
    }
    
    init(key: StringKey, _ arguments: CVarArg...) {
        self.init(template: .init(key: key.rawValue, arguments: arguments))
    }
    
    init(key: StringKey, arguments: [CVarArg]) {
        self.init(template: .init(key: key.rawValue, arguments: arguments))
    }
}

extension Text {
    init(key: StringKey) {
        self.init(LocalizedStringKey(key.rawValue), bundle: .module)
    }
    
    init(template: StringTemplate) {
        self.init(String(template: template))
    }
}
