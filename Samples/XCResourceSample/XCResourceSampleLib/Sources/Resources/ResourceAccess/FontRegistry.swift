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
        for fontResource in FontResource.all {
            registerFont(with: fontResource)
        }
    }
    
    public func registerFontFamilyIfNeeded(for resource: FontResource) {
        if !hasRegisteredFont(for: resource) {
            registerFontFamily(name: resource.familyName)
        }
    }
    
    public func registerFontFamily(name familyName: String) {
        let fontResources = FontResource.all.filter({ $0.familyName == familyName })
        
        for fontResource in fontResources {
            registerFont(with: fontResource)
        }
    }
    
    private func registerFont(with fontResource: FontResource) {
        do {
            let fontURL = fontResource.url as CFURL
            var errRef: Unmanaged<CFError>?
            let isRegistered = CTFontManagerRegisterFontsForURL(fontURL, .process, &errRef)
            let error = errRef?.takeUnretainedValue() as Error?
            let isIgnorable = error.map(isIgnorableError(_:)) ?? false
            
            if !isRegistered && !isIgnorable {
                throw FontError.registrationFailed(path: fontResource.relativePath, error: error)
            }
        } catch {
            preconditionFailure("\(error)")
        }
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
        case registrationFailed(path: String, error: Error?)
    }
}
