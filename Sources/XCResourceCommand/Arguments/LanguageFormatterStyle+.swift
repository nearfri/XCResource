import Foundation
import ArgumentParser
import LocCSVGen

extension LanguageFormatterStyle: ExpressibleByArgument {
    public init?(argument: String) {
        if argument == "short" {
            self = .short
            return
        }
        
        if argument == "long" {
            self = .long(Locale.current)
            return
        }
        
        if argument.hasPrefix("long-") {
            let localeID = String(argument.dropFirst("long-".count))
            self = .long(Locale(identifier: localeID))
            return
        }
        
        return nil
    }
    
    public var defaultValueDescription: String {
        switch self {
        case .short:
            return "short"
        case .long(let locale):
            return locale == .current ? "long" : "long-\(locale.identifier)"
        }
    }
    
    public static var allValueStrings: [String] {
        return ["short", "long", "long-<language>"]
    }
    
    static var joinedAllValuesString: String {
        return allValueStrings.joined(separator: "|")
    }
}
