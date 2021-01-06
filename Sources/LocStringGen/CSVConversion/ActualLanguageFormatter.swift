import Foundation

class ActualLanguageFormatter: LanguageFormatter {
    var style: LanguageFormatterStyle = .short
    
    private let regex: NSRegularExpression = try! .init(pattern: #".+ \((.+)\)$"#)
    
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
            return LanguageID(string)
        case .long:
            let searchRange = NSRange(string.startIndex..., in: string)
            let language = regex.firstMatch(in: string, range: searchRange)
                .flatMap({ Range($0.range(at: 1), in: string) })
                .map({ String(string[$0]) })
            
            return language.map({ LanguageID($0) })
        }
    }
}
