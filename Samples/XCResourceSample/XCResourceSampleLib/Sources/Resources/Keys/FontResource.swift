// This file was generated by xcresource
// Do Not Edit Directly!

import Foundation

public struct FontResource: Hashable, Sendable {
    public let fontName: String
    public let familyName: String
    public let style: String
    public let relativePath: String
    public let bundle: Bundle
    
    public init(
        fontName: String,
        familyName: String,
        style: String,
        relativePath: String,
        bundle: Bundle
    ) {
        self.fontName = fontName
        self.familyName = familyName
        self.style = style
        self.relativePath = relativePath
        self.bundle = bundle
    }
    
    public var url: URL {
        return URL(filePath: relativePath, relativeTo: bundle.resourceURL).standardizedFileURL
    }
    
    public var path: String {
        return url.path(percentEncoded: false)
    }
}

public extension FontResource {
    static let all: [FontResource] = [
        // Cambria
        .cambriaRegular,
        
        // Cambria Math
        .cambriaMathRegular,
        
        // Open Sans
        .openSansBold,
        .openSansBoldItalic,
        .openSansExtraBold,
        .openSansExtraBoldItalic,
        .openSansItalic,
        .openSansLight,
        .openSansLightItalic,
        .openSansMedium,
        .openSansMediumItalic,
        .openSansRegular,
        .openSansSemiBold,
        .openSansSemiBoldItalic,
    ]
}

public extension FontResource {
    // MARK: Cambria
    
    static let cambriaRegular: FontResource = .init(
        fontName: "Cambria",
        familyName: "Cambria",
        style: "Regular",
        relativePath: "Fonts/Cambria.ttc",
        bundle: Bundle.module)
    
    // MARK: Cambria Math
    
    static let cambriaMathRegular: FontResource = .init(
        fontName: "CambriaMath",
        familyName: "Cambria Math",
        style: "Regular",
        relativePath: "Fonts/Cambria.ttc",
        bundle: Bundle.module)
    
    // MARK: Open Sans
    
    static let openSansBold: FontResource = .init(
        fontName: "OpenSans-Bold",
        familyName: "Open Sans",
        style: "Bold",
        relativePath: "Fonts/OpenSans/OpenSans-Bold.ttf",
        bundle: Bundle.module)
    
    static let openSansBoldItalic: FontResource = .init(
        fontName: "OpenSans-BoldItalic",
        familyName: "Open Sans",
        style: "Bold Italic",
        relativePath: "Fonts/OpenSans/OpenSans-BoldItalic.ttf",
        bundle: Bundle.module)
    
    static let openSansExtraBold: FontResource = .init(
        fontName: "OpenSans-ExtraBold",
        familyName: "Open Sans",
        style: "ExtraBold",
        relativePath: "Fonts/OpenSans/OpenSans-ExtraBold.ttf",
        bundle: Bundle.module)
    
    static let openSansExtraBoldItalic: FontResource = .init(
        fontName: "OpenSans-ExtraBoldItalic",
        familyName: "Open Sans",
        style: "ExtraBold Italic",
        relativePath: "Fonts/OpenSans/OpenSans-ExtraBoldItalic.ttf",
        bundle: Bundle.module)
    
    static let openSansItalic: FontResource = .init(
        fontName: "OpenSans-Italic",
        familyName: "Open Sans",
        style: "Italic",
        relativePath: "Fonts/OpenSans/OpenSans-Italic.ttf",
        bundle: Bundle.module)
    
    static let openSansLight: FontResource = .init(
        fontName: "OpenSans-Light",
        familyName: "Open Sans",
        style: "Light",
        relativePath: "Fonts/OpenSans/OpenSans-Light.ttf",
        bundle: Bundle.module)
    
    static let openSansLightItalic: FontResource = .init(
        fontName: "OpenSans-LightItalic",
        familyName: "Open Sans",
        style: "Light Italic",
        relativePath: "Fonts/OpenSans/OpenSans-LightItalic.ttf",
        bundle: Bundle.module)
    
    static let openSansMedium: FontResource = .init(
        fontName: "OpenSans-Medium",
        familyName: "Open Sans",
        style: "Medium",
        relativePath: "Fonts/OpenSans/OpenSans-Medium.ttf",
        bundle: Bundle.module)
    
    static let openSansMediumItalic: FontResource = .init(
        fontName: "OpenSans-MediumItalic",
        familyName: "Open Sans",
        style: "Medium Italic",
        relativePath: "Fonts/OpenSans/OpenSans-MediumItalic.ttf",
        bundle: Bundle.module)
    
    static let openSansRegular: FontResource = .init(
        fontName: "OpenSans-Regular",
        familyName: "Open Sans",
        style: "Regular",
        relativePath: "Fonts/OpenSans/OpenSans-Regular.ttf",
        bundle: Bundle.module)
    
    static let openSansSemiBold: FontResource = .init(
        fontName: "OpenSans-SemiBold",
        familyName: "Open Sans",
        style: "SemiBold",
        relativePath: "Fonts/OpenSans/OpenSans-SemiBold.ttf",
        bundle: Bundle.module)
    
    static let openSansSemiBoldItalic: FontResource = .init(
        fontName: "OpenSans-SemiBoldItalic",
        familyName: "Open Sans",
        style: "SemiBold Italic",
        relativePath: "Fonts/OpenSans/OpenSans-SemiBoldItalic.ttf",
        bundle: Bundle.module)
}
