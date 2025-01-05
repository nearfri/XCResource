import Foundation
import OrderedCollections

// https://developer.apple.com/documentation/xcode/creating-width-and-device-variants-of-strings#Provide-device-specific-string-variants
struct DeviceSpecificRule: Equatable, Sendable {
    var key: String
    var stringsByDevice: OrderedDictionary<String, String>
}

extension DeviceSpecificRule {
    init(key: String, info: PlistDictionary) throws {
        let rules = try info.value(forKey: StringsdictKey.deviceRuleType,
                                   type: PlistDictionary.self)
        
        self.key = key
        self.stringsByDevice = try rules.mapValues({ plist in
            guard let value = plist.stringValue else {
                throw Plist.KeyValueError.typeMismatch(expected: String.self,
                                                       actual: type(of: plist.value))
            }
            return value
        })
    }
    
    func toLocalizationItem() -> LocalizationItem {
        return LocalizationItem(key: key, value: stringsByDevice.values.first ?? key)
    }
}
