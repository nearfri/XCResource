// Generated from resourcekey.
// Do Not Edit Directly!

struct ColorKey: ExpressibleByStringLiteral, Hashable {
    var rawValue: String
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

// MARK: - Media.xcassets

extension ColorKey {
    static let accentColor: ColorKey = "AccentColor"
    
    // MARK: Color
    static let battleshipGrey8: ColorKey = "battleshipGrey8"
    static let battleshipGrey12: ColorKey = "battleshipGrey12"
    static let black5: ColorKey = "black5"
    static let blueBlue: ColorKey = "blueBlue"
    static let blush: ColorKey = "blush"
    static let brownGrey: ColorKey = "brownGrey"
    static let white30: ColorKey = "white30"
    static let wisteria: ColorKey = "wisteria"
}
