// This file was generated by xcresource
// Do Not Edit Directly!

public struct FontKey: Hashable {
    public var fontName: String
    public var familyName: String
    public var style: String
    public var path: String
    
    public init(fontName: String, familyName: String, style: String, path: String) {
        self.fontName = fontName
        self.familyName = familyName
        self.style = style
        self.path = path
    }
}

public extension FontKey {
    static let allKeys: [FontKey] = [
        // Cambria
        .cambria_regular,
        
        // Cambria Math
        .cambriaMath_regular,
        
        // Open Sans
        .openSans_bold,
        .openSans_boldItalic,
        .openSans_extraBold,
        .openSans_extraBoldItalic,
        .openSans_italic,
        .openSans_light,
        .openSans_lightItalic,
        .openSans_medium,
        .openSans_mediumItalic,
        .openSans_regular,
        .openSans_semiBold,
        .openSans_semiBoldItalic,
    ]
}

public extension FontKey {
    // MARK: Cambria
    
    static let cambria_regular: FontKey = .init(
        fontName: "Cambria",
        familyName: "Cambria",
        style: "Regular",
        path: "Cambria.ttc")
    
    // MARK: Cambria Math
    
    static let cambriaMath_regular: FontKey = .init(
        fontName: "CambriaMath",
        familyName: "Cambria Math",
        style: "Regular",
        path: "Cambria.ttc")
    
    // MARK: Open Sans
    
    static let openSans_bold: FontKey = .init(
        fontName: "OpenSans-Bold",
        familyName: "Open Sans",
        style: "Bold",
        path: "OpenSans/OpenSans-Bold.ttf")
    
    static let openSans_boldItalic: FontKey = .init(
        fontName: "OpenSans-BoldItalic",
        familyName: "Open Sans",
        style: "Bold Italic",
        path: "OpenSans/OpenSans-BoldItalic.ttf")
    
    static let openSans_extraBold: FontKey = .init(
        fontName: "OpenSans-ExtraBold",
        familyName: "Open Sans",
        style: "ExtraBold",
        path: "OpenSans/OpenSans-ExtraBold.ttf")
    
    static let openSans_extraBoldItalic: FontKey = .init(
        fontName: "OpenSans-ExtraBoldItalic",
        familyName: "Open Sans",
        style: "ExtraBold Italic",
        path: "OpenSans/OpenSans-ExtraBoldItalic.ttf")
    
    static let openSans_italic: FontKey = .init(
        fontName: "OpenSans-Italic",
        familyName: "Open Sans",
        style: "Italic",
        path: "OpenSans/OpenSans-Italic.ttf")
    
    static let openSans_light: FontKey = .init(
        fontName: "OpenSans-Light",
        familyName: "Open Sans",
        style: "Light",
        path: "OpenSans/OpenSans-Light.ttf")
    
    static let openSans_lightItalic: FontKey = .init(
        fontName: "OpenSans-LightItalic",
        familyName: "Open Sans",
        style: "Light Italic",
        path: "OpenSans/OpenSans-LightItalic.ttf")
    
    static let openSans_medium: FontKey = .init(
        fontName: "OpenSans-Medium",
        familyName: "Open Sans",
        style: "Medium",
        path: "OpenSans/OpenSans-Medium.ttf")
    
    static let openSans_mediumItalic: FontKey = .init(
        fontName: "OpenSans-MediumItalic",
        familyName: "Open Sans",
        style: "Medium Italic",
        path: "OpenSans/OpenSans-MediumItalic.ttf")
    
    static let openSans_regular: FontKey = .init(
        fontName: "OpenSans-Regular",
        familyName: "Open Sans",
        style: "Regular",
        path: "OpenSans/OpenSans-Regular.ttf")
    
    static let openSans_semiBold: FontKey = .init(
        fontName: "OpenSans-SemiBold",
        familyName: "Open Sans",
        style: "SemiBold",
        path: "OpenSans/OpenSans-SemiBold.ttf")
    
    static let openSans_semiBoldItalic: FontKey = .init(
        fontName: "OpenSans-SemiBoldItalic",
        familyName: "Open Sans",
        style: "SemiBold Italic",
        path: "OpenSans/OpenSans-SemiBoldItalic.ttf")
}