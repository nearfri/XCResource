// Generated from generate-asset-keys.
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

// MARK: - Assets.xcassets

extension ColorKey {
    static let accentColor: ColorKey = "AccentColor"
    
    // MARK: Color
    static let battleshipGrey8: ColorKey = "battleshipGrey8"
    static let battleshipGrey12: ColorKey = "battleshipGrey12"
    static let cobalt: ColorKey = "cobalt"
    static let coral: ColorKey = "coral"
    static let coralPink: ColorKey = "coralPink"
    static let coralTwo: ColorKey = "coralTwo"
    static let darkBrown: ColorKey = "darkBrown"
    static let lightRose: ColorKey = "lightRose"
    static let marigold: ColorKey = "marigold"
    static let milkChocolate: ColorKey = "milkChocolate"
    static let offWhite: ColorKey = "offWhite"
    static let orangered: ColorKey = "orangered"
    static let orangeyRed: ColorKey = "orangeyRed"
    static let orangeyRedTwo: ColorKey = "orangeyRedTwo"
    static let paleGrey18: ColorKey = "paleGrey18"
    static let paleGrey30: ColorKey = "paleGrey30"
    static let paleGrey60: ColorKey = "paleGrey60"
    static let warmBlue: ColorKey = "warmBlue"
    static let warmGrey: ColorKey = "warmGrey"
    static let weirdGreen: ColorKey = "weirdGreen"
    static let white5: ColorKey = "white5"
    static let wisteria: ColorKey = "wisteria"
}
