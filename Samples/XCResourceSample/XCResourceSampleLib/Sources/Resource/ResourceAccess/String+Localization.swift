import Foundation

public extension String {
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
        return String(format: format, arguments: form.arguments)
    }
}
