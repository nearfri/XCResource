import Foundation

class DefaultLanguageFormatter: LanguageFormatter {
    var style: LanguageFormatterStyle = .short
    
    private let longStyleRegex: NSRegularExpression = try! .init(pattern: #".+ \((.+)\)$"#)
    
    func string(from language: LanguageID) -> String {
        switch style {
        case .short:
            return language.rawValue
        case .long(let locale):
            let localizedString = locale.localizedString(forIdentifier: language.rawValue)
            return "\(localizedString ?? language.rawValue) (\(language.rawValue))"
        }
    }
    
    func language(from string: String) -> LanguageID? {
        switch style {
        case .short:
            let isInvalid = string.contains(" ") || string.hasSuffix(")")
            return isInvalid ? nil : LanguageID(string)
        case .long:
            let searchRange = NSRange(string.startIndex..., in: string)
            let language = longStyleRegex.firstMatch(in: string, range: searchRange)
                .flatMap({ Range($0.range(at: 1), in: string) })
                .map({ String(string[$0]) })
            
            return language.map({ LanguageID($0) })
        }
    }
}
