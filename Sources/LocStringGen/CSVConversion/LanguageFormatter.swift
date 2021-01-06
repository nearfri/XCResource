import Foundation

public enum LanguageFormatterStyle {
    case short
    case long(Locale)
}

protocol LanguageFormatter: AnyObject {
    var style: LanguageFormatterStyle { get set }
    
    func string(from language: LanguageID) -> String
    func language(from string: String) -> LanguageID?
}
