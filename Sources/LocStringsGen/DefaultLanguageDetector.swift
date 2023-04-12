import Foundation
import LocStringCore

class DefaultLanguageDetector: LanguageDetector {
    private let detector: LocStringCore.LanguageDetector
    
    init(detector: LocStringCore.LanguageDetector) {
        self.detector = detector
    }
    
    func detect<S: Sequence<LanguageID>>(at url: URL, allowedLanguages: S) throws -> [LanguageID] {
        let availableLanguages = try detector.detect(at: url)
        let allowedLanguages = Set(allowedLanguages)
        
        if allowedLanguages.contains(.all) {
            return availableLanguages
        }
        
        return availableLanguages.filter(allowedLanguages.contains(_:))
    }
}
