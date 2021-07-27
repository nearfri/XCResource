import Foundation
import SwiftUI

extension String {
    static func localized(_ key: StringKey) -> String {
        return NSLocalizedString(key.rawValue, bundle: .module, comment: "")
    }
    
    static func localized(_ key: StringKey, _ arguments: CVarArg...) -> String {
        return formatted(.init(key: key.rawValue, arguments: arguments))
    }
    
    static func localized(_ key: StringKey, arguments: [CVarArg]) -> String {
        return formatted(.init(key: key.rawValue, arguments: arguments))
    }
    
    static func formatted(_ form: StringForm) -> String {
        let format = NSLocalizedString(form.key, bundle: .module, comment: "")
        return String(format: format, locale: .current, arguments: form.arguments)
    }
}

extension Text {
    init(key: StringKey) {
        self.init(LocalizedStringKey(key.rawValue), bundle: .module)
    }
    
    init(form: StringForm) {
        self.init(String.formatted(form))
    }
}
