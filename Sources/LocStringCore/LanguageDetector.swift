import Foundation

public protocol LanguageDetector: AnyObject {
    func detect(at url: URL) throws -> [LanguageID]
}
