import Foundation

class ActualLanguageDetector: LanguageDetector {
    func detect(at url: URL) throws -> [LanguageID] {
        let pathExtension = ".lproj"
        return try FileManager.default
            .contentsOfDirectory(atPath: url.path)
            .filter({ $0.hasSuffix(pathExtension) })
            .map({ $0[..<$0.index($0.endIndex, offsetBy: -pathExtension.count)] })
            .map({ LanguageID(rawValue: String($0)) })
    }
}
