import Foundation

public enum StringsdictKey {
    public static let format: String = "NSStringLocalizedFormatKey"
    public static let widthRuleType: String = "NSStringVariableWidthRuleType"
    public static let deviceRuleType: String = "NSStringDeviceSpecificRuleType"
    
    public enum Plural {
        public static let specType: String = "NSStringFormatSpecTypeKey"
        public static let ruleType: String = "NSStringPluralRuleType"
        public static let valueType: String = "NSStringFormatValueTypeKey"
        public static let categoryOther: String = "other"
        public static let categoryZero: String = "zero"
        public static let categoryOne: String = "one"
    }
}
