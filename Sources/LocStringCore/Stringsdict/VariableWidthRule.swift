import Foundation
import OrderedCollections

// https://developer.apple.com/documentation/xcode/creating-width-and-device-variants-of-strings#Provide-string-variants-for-different-widths
struct VariableWidthRule: Equatable {
    var key: String
    var stringsByWidth: OrderedDictionary<String, String>
}

extension VariableWidthRule {
    init(key: String, info: PlistDictionary) throws {
        let rules = try info.value(forKey: StringsdictKey.widthRuleType, type: PlistDictionary.self)
        
        self.key = key
        self.stringsByWidth = try rules.mapValues({ plist in
            guard let value = plist.stringValue else {
                throw Plist.KeyValueError.typeMismatch(expected: String.self,
                                                       actual: type(of: plist.value))
            }
            return value
        })
    }
    
    func toLocalizationItem() -> LocalizationItem {
        return LocalizationItem(key: key, value: stringsByWidth.values.last ?? key)
    }
}
