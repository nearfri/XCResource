import Foundation

extension ImageKey {
    static func textStyleIcon(for type: TextStyleType) -> ImageKey {
        switch type {
        case .bold:
            return .textFormattingBold
        case .italic:
            return .textFormattingItalics
        case .strikethrough:
            return .textFormattingStrikethrough
        case .undeline:
            return .textFormattingUnderline
        }
    }
}
