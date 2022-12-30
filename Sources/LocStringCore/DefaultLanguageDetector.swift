import Foundation

public class DefaultLanguageDetector: LanguageDetector {
    public init() {}
    
    public func detect(at url: URL) throws -> [LanguageID] {
        let pathExtension = ".lproj"
        return try FileManager.default
            .contentsOfDirectory(atPath: url.path)
            .filter({ $0.hasSuffix(pathExtension) })
            .filter({ $0 != "Base" + pathExtension })
            .map({ $0[..<$0.index($0.endIndex, offsetBy: -pathExtension.count)] })
            .map({ LanguageID(String($0)) })
    }
}
