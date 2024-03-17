import Foundation

struct StringCatalogDTO: Codable, Hashable {
    var version: String
    var sourceLanguage: String
    var strings: [String: StringDTO] // key: localized string key
}

struct StringDTO: Codable, Hashable {
    var comment: String?
    var extractionState: String? // extracted_with_value, manual, migrated
    var localizations: [String: LocalizationDTO] // key: language
}

// required: stringUnit or variations
// optional: substitutions
struct LocalizationDTO: Codable, Hashable {
    var stringUnit: StringUnitDTO?
    var variations: DeviceVariationsDTO?
    var substitutions: [String: SubstitutionDTO]? // %#@key@
}

struct StringUnitDTO: Codable, Hashable {
    var state: String // new, needs_review, translated
    var value: String
}

struct SubstitutionDTO: Codable, Hashable {
    var argNum: Int?
    var formatSpecifier: String // lld, lf
    var variations: PluralVariationsDTO
}

struct DeviceVariationsDTO: Codable, Hashable {
    var device: [String: VariationValueDTO] // key: DeviceDTO
}

struct PluralVariationsDTO: Codable, Hashable {
    var plural: [String: VariationValueDTO] // key: PluralDTO
}

struct VariationValueDTO: Codable, Hashable {
    var stringUnit: StringUnitDTO
}

enum DeviceDTO: String {
    case appleTV = "appletv"
    case appleVision = "applevision"
    case appleWatch = "applewatch"
    case iPad = "ipad"
    case iPhone = "iphone"
    case iPod = "ipod"
    case mac = "mac"
    case other = "other"
}

enum PluralDTO: String {
    case few
    case many
    case one
    case other
    case zero
}
