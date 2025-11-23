import Foundation

struct StringCatalogDTO: Codable, Hashable, Sendable {
    var version: String
    var sourceLanguage: String
    var strings: [String: StringDTO] // key: localized string key
}

struct StringDTO: Codable, Hashable, Sendable {
    var comment: String?
    var extractionState: String? // extracted_with_value, manual, migrated
    var generatesSymbol: Bool?
    var localizations: [String: LocalizationDTO] // key: language
}

// required: stringUnit or variations
// optional: substitutions
struct LocalizationDTO: Codable, Hashable, Sendable {
    var stringUnit: StringUnitDTO?
    var variations: VariationsDTO?
    var substitutions: [String: SubstitutionDTO]? // %#@key@
    
    var allStringUnits: [StringUnitDTO] {
        var result = stringUnit.map({ [$0] }) ?? []
        
        if let variations {
            result.append(contentsOf: variations.allStringUnits)
        }
        
        if let substitutions {
            for (_, substitution) in substitutions {
                result.append(contentsOf: substitution.allStringUnits)
            }
        }
        
        return result
    }
}

struct StringUnitDTO: Codable, Hashable, Sendable {
    var state: String // new, needs_review, translated
    var value: String
}

struct SubstitutionDTO: Codable, Hashable, Sendable {
    var argNum: Int?
    var formatSpecifier: String // lld, lf
    var variations: PluralVariationsDTO
    
    var allStringUnits: [StringUnitDTO] {
        return variations.allStringUnits
    }
}

enum VariationsDTO: Codable, Hashable, Sendable {
    case device(DeviceVariationsDTO)
    case plural(PluralVariationsDTO)
    
    enum CodingKeys: String, CodingKey {
        case device
        case plural
    }
    
    init(from decoder: any Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let singleContainer = try decoder.singleValueContainer()
        
        switch keyedContainer.allKeys.first {
        case .device:
            self = .device(try singleContainer.decode(DeviceVariationsDTO.self))
        case .plural:
            self = .plural(try singleContainer.decode(PluralVariationsDTO.self))
        default:
            throw DecodingError.typeMismatch(VariationsDTO.self, .init(
                codingPath: keyedContainer.codingPath,
                debugDescription: "Expected either 'device' or 'plural' key in VariationsDTO"))
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .device(let deviceVariationsDTO):
            try container.encode(deviceVariationsDTO)
        case .plural(let pluralVariationsDTO):
            try container.encode(pluralVariationsDTO)
        }
    }
    
    var allStringUnits: [StringUnitDTO] {
        switch self {
        case .device(let deviceVariationsDTO):
            return deviceVariationsDTO.allStringUnits
        case .plural(let pluralVariationsDTO):
            return pluralVariationsDTO.allStringUnits
        }
    }
}

struct DeviceVariationsDTO: Codable, Hashable, Sendable {
    var device: [String: DeviceVariationValueDTO] // key: DeviceDTO
    
    var allStringUnits: [StringUnitDTO] {
        return device.values.flatMap(\.allStringUnits)
    }
    
    var primaryStringUnit: StringUnitDTO? {
        let valuesByDevice = valuesByDevice
        let preferredDeviceDTOs: [DeviceDTO] = [.iPhone, .mac, .other]
        if let deviceDTO = preferredDeviceDTOs.first(where: { valuesByDevice[$0] != nil }) {
            return valuesByDevice[deviceDTO]?.primaryStringUnit
        }
        return valuesByDevice
            .sorted(by: { $0.key.rawValue < $1.key.rawValue })
            .first?.value.primaryStringUnit
    }
    
    var valuesByDevice: [DeviceDTO: DeviceVariationValueDTO] {
        return device.reduce(into: [:]) { partialResult, each in
            let (deviceName, variationValueDTO) = each
            if let deviceDTO = DeviceDTO(rawValue: deviceName) {
                partialResult[deviceDTO] = variationValueDTO
            }
        }
    }
}

enum DeviceVariationValueDTO: Codable, Hashable, Sendable {
    case stringUnit(StringUnitDTO)
    case variations(PluralVariationsDTO)
    
    enum CodingKeys: String, CodingKey {
        case stringUnit
        case variations
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch container.allKeys.first {
        case .stringUnit:
            self = .stringUnit(try container.decode(StringUnitDTO.self, forKey: .stringUnit))
        case .variations:
            self = .variations(try container.decode(PluralVariationsDTO.self, forKey: .variations))
        default:
            throw DecodingError.typeMismatch(VariationsDTO.self, .init(
                codingPath: container.codingPath,
                debugDescription: """
                    Expected either 'stringUnit' or 'variations' key in VariationValueDTO
                    """))
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .stringUnit(let stringUnitDTO):
            try container.encode(stringUnitDTO, forKey: .stringUnit)
        case .variations(let pluralVariationsDTO):
            try container.encode(pluralVariationsDTO, forKey: .variations)
        }
    }
    
    var allStringUnits: [StringUnitDTO] {
        switch self {
        case .stringUnit(let stringUnitDTO):
            return [stringUnitDTO]
        case .variations(let pluralVariationsDTO):
            return pluralVariationsDTO.allStringUnits
        }
    }
    
    var primaryStringUnit: StringUnitDTO? {
        switch self {
        case .stringUnit(let stringUnitDTO):
            return stringUnitDTO
        case .variations(let pluralVariationsDTO):
            return pluralVariationsDTO.primaryStringUnit
        }
    }
}

struct PluralVariationsDTO: Codable, Hashable, Sendable {
    var plural: [String: PluralVariationValueDTO] // key: PluralDTO
    
    var allStringUnits: [StringUnitDTO] {
        return plural.values.map(\.stringUnit)
    }
    
    var primaryStringUnit: StringUnitDTO? {
        if let valueDTO = plural[PluralDTO.other.rawValue] {
            return valueDTO.stringUnit
        }
        return plural.sorted(by: { $0.key < $1.key }).first?.value.stringUnit
    }
}

struct PluralVariationValueDTO: Codable, Hashable, Sendable {
    var stringUnit: StringUnitDTO
}

enum DeviceDTO: String, Sendable {
    case appleTV = "appletv"
    case appleVision = "applevision"
    case appleWatch = "applewatch"
    case iPad = "ipad"
    case iPhone = "iphone"
    case iPod = "ipod"
    case mac = "mac"
    case other = "other"
}

enum PluralDTO: String, Sendable {
    case few
    case many
    case one
    case other
    case zero
}
