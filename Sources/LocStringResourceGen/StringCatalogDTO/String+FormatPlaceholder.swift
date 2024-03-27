import Foundation
import StrixParsers

extension String {
    init(formatPlaceholder: FormatPlaceholder) {
        switch (formatPlaceholder.length, formatPlaceholder.conversion) {
        case (.longLong, .decimal): // lld
            self = "Int"
        case (.longLong, .unsigned): // llu
            self = "UInt"
        case (nil, .float): // f
            self = "Float"
        case (nil, .object): // @
            self = "String"
        default:
            self = String(describing: formatPlaceholder.valueType)
        }
    }
}
