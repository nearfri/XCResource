import Foundation
import CoreText

class FontLoader {
    func load(at path: String, relativeTo baseURL: URL) throws -> [Font] {
        let fontURL = baseURL.appendingPathComponent(path) as CFURL
        
        guard let descs = CTFontManagerCreateFontDescriptorsFromURL(fontURL),
              let descriptors = descs as? [CTFontDescriptor]
        else { throw FontError.descriptorCreationFailed }
        
        return descriptors.map { descriptor in
            let options: CTFontOptions = [.preventAutoActivation]
            let font = CTFontCreateWithFontDescriptorAndOptions(descriptor, 0, nil, options)
            
            let postScriptName = CTFontCopyPostScriptName(font) as String
            let familyName = CTFontCopyFamilyName(font) as String
            let style = (CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String) ?? ""
            
            return Font(fontName: postScriptName,
                        familyName: familyName,
                        style: style,
                        path: path)
        }
    }
}
