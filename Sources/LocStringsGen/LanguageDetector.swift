import Foundation
import LocStringCore

protocol LanguageDetector: AnyObject {
    func detect<S: Sequence<LanguageID>>(at url: URL, allowedLanguages: S) throws -> [LanguageID]
}
