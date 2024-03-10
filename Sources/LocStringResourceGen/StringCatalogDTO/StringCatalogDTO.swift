import Foundation

struct StringCatalogDTO: Codable, Hashable {
    var version: String
    var sourceLanguage: String
    var strings: [String: StringDTO]
}

struct StringDTO: Codable, Hashable {
    var comment: String?
    var extractionState: String? // extracted_with_value, migrated
    var localizations: [String: LocalizationDTO] // key: locale-id
}

// required: stringUnit or variations
// optional: substitutions
struct LocalizationDTO: Codable, Hashable {
    var stringUnit: StringUnitDTO?
    var variations: VariationsDTO? // device variations
    var substitutions: [String: SubstitutionDTO]? // %#@key@
}

struct StringUnitDTO: Codable, Hashable {
    var state: String // new, needs_review, translated
    var value: String
}

struct SubstitutionDTO: Codable, Hashable {
    var argNum: Int?
    var formatSpecifier: String // lld, lf
    var variations: VariationsDTO // plural variations
}

struct VariationsDTO: Codable, Hashable {
    var device: [String: StringUnitContainerDTO]? // key: DeviceDTO
    var plural: [String: StringUnitContainerDTO]? // key: PluralDTO
}

struct StringUnitContainerDTO: Codable, Hashable {
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
