import Foundation
import CoreText

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
private typealias NativeFont = UIFont
#elseif os(macOS)
import AppKit.NSFont
private typealias NativeFont = NSFont
#endif

public class FontRegistry {
    private init() {}
    
    public static let shared: FontRegistry = .init()
    
    public func hasRegisteredFont(for resource: FontResource) -> Bool {
        return NativeFont(name: resource.fontName, size: 10) != nil
    }
    
    public func registerAllFonts() {
        let fontPaths = Set(FontResource.all.map(\.path))
        
        for fontPath in fontPaths {
            registerFont(atPath: fontPath)
        }
    }
    
    public func registerFontFamilyIfNeeded(for resource: FontResource) {
        if !hasRegisteredFont(for: resource) {
            registerFontFamily(name: resource.familyName)
        }
    }
    
    public func registerFontFamily(name familyName: String) {
        let fontPaths = Set(FontResource.all.filter({ $0.familyName == familyName }).map(\.path))
        
        for fontPath in fontPaths {
            registerFont(atPath: fontPath)
        }
    }
    
    private func registerFont(atPath path: String) {
        do {
            guard let fontsDirectoryURL else {
                throw FontError.fontsDirectoryNotFound
            }
            
            let fontURL = fontsDirectoryURL.appendingPathComponent(path)
            
            var errRef: Unmanaged<CFError>?
            let isRegistered = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &errRef)
            let error = errRef?.takeUnretainedValue() as Error?
            let isIgnorable = error.map(isIgnorableError(_:)) ?? false
            
            if !isRegistered && !isIgnorable {
                throw FontError.registrationFailed(path: path, error: error)
            }
        } catch {
            preconditionFailure("\(error)")
        }
    }
    
    private var fontsDirectoryURL: URL? {
        return Bundle.module.url(forResource: "Fonts", withExtension: nil)
    }
    
    private func isIgnorableError(_ error: Error) -> Bool {
        let nsError = error as NSError
        
        if nsError.domain != (kCTFontManagerErrorDomain as String) {
            return false
        }
        
        switch CTFontManagerError(rawValue: nsError.code) {
        case .alreadyRegistered, .duplicatedName:
            return true
        default:
            return false
        }
    }
}

extension FontRegistry {
    private enum FontError: Error {
        case fontsDirectoryNotFound
        case registrationFailed(path: String, error: Error?)
    }
}
