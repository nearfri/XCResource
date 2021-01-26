import Foundation
import SwiftUI

extension String {
    init(key: StringKey) {
        self = NSLocalizedString(key.rawValue, bundle: .module, comment: "")
    }
    
    init(form: StringForm) {
        let format = NSLocalizedString(form.key, bundle: .module, comment: "")
        self.init(format: format, locale: .current, arguments: form.arguments)
    }
    
    init(key: StringKey, _ arguments: CVarArg...) {
        self.init(form: .init(key: key.rawValue, arguments: arguments))
    }
    
    init(key: StringKey, arguments: [CVarArg]) {
        self.init(form: .init(key: key.rawValue, arguments: arguments))
    }
}

extension Text {
    init(key: StringKey) {
        self.init(LocalizedStringKey(key.rawValue), bundle: .module)
    }
    
    init(form: StringForm) {
        self.init(String(form: form))
    }
}
