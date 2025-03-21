import Foundation
import RegexBuilder
import Strix
import StrixParsers

extension StringCatalogDTOMapper {
    private struct FormatInfo {
        let substitutedFormatUnits: [FormatUnit]
        let sortedFormatUnits: [FormatUnit]
    }
    
    enum Error: Swift.Error {
        case stringUnitDoesNotExist(key: String)
    }
}

struct StringCatalogDTOMapper {
    private let formatUnitsParser: Parser<[FormatUnit]> = Parser.formatUnits
    
    private let formatPlaceholderParser: Parser<FormatPlaceholder>
    
    init() {
        self.formatPlaceholderParser = Parser.formatSpecifierContent
            .map({ specifier throws(ParseError) in
                switch specifier {
                case .percentSign:
                    throw ParseError.generic(message: "invalid format specifier '%'")
                case .placeholder(let formatPlaceholder):
                    return formatPlaceholder
                }
            })
    }
    
    func localizationItems(from dto: StringCatalogDTO) throws -> [LocalizationItem] {
        return try dto.strings.reduce(into: []) { partialResult, each in
            let (key, stringDTO) = each
            let localizationDTO = {
                if let ret = stringDTO.localizations[dto.sourceLanguage] { return ret }
                return LocalizationDTO(stringUnit: StringUnitDTO(state: "new", value: key))
            }()
            
            let localizationItem = try localizationItem(from: localizationDTO, key: key)
                .with(\.translationComment, stringDTO.comment)
            
            partialResult.append(localizationItem)
        }
        .sorted(by: { $0.key < $1.key })
    }
    
    private func localizationItem(
        from dto: LocalizationDTO,
        key: String
    ) throws -> LocalizationItem {
        guard let stringUnitDTO = stringUnitDTO(from: dto) else {
            throw Error.stringUnitDoesNotExist(key: key)
        }
        
        let formatInfo = try formatInfo(from: stringUnitDTO,
                                        substitutions: dto.substitutions ?? [:])
        
        let defaultValue = defaultValue(from: stringUnitDTO, formatInfo: formatInfo)
        
        let methodParameters = methodParameters(from: formatInfo.sortedFormatUnits)
        
        let memberDeclaration = if methodParameters.isEmpty {
            LocalizationItem.MemberDeclaration.property(key.toIdentifier())
        } else {
            LocalizationItem.MemberDeclaration.method(key.toIdentifier(), methodParameters)
        }
        
        return LocalizationItem(
            key: key,
            defaultValue: defaultValue,
            rawDefaultValue: stringUnitDTO.escapedValue,
            memberDeclaration: memberDeclaration)
    }
    
    private func stringUnitDTO(from dto: LocalizationDTO) -> StringUnitDTO? {
        if let stringUnit = dto.stringUnit {
            return stringUnit
        }
        
        guard let variations = dto.variations else {
            return nil
        }
        
        let stringUnitDTOsByDevice: [DeviceDTO: StringUnitDTO] = variations.device
            .reduce(into: [:]) { partialResult, each in
                let (deviceName, variationValueDTO) = each
                if let deviceDTO = DeviceDTO(rawValue: deviceName) {
                    partialResult[deviceDTO] = variationValueDTO.stringUnit
                }
            }
        
        let preferredDeviceDTOs: [DeviceDTO] = [.iPhone, .mac, .other]
        for preferredDeviceDTO in preferredDeviceDTOs {
            if let stringUnitDTO = stringUnitDTOsByDevice[preferredDeviceDTO] {
                return stringUnitDTO
            }
        }
        
        return stringUnitDTOsByDevice.first?.value
    }
    
    private func formatInfo(
        from dto: StringUnitDTO,
        substitutions: [String: SubstitutionDTO]
    ) throws -> FormatInfo {
        let formatUnits = try formatUnitsParser.run(dto.escapedValue)
        
        let substitutedFormatUnits = try formatUnits.map { formatUnit in
            guard let placeholder = formatUnit.placeholder,
                  let variableName = placeholder.variableName,
                  let substitution = substitutions[variableName]
            else { return formatUnit }
            
            let substitutedPlaceholder = try placeholder.applying(substitution,
                                                                  using: formatPlaceholderParser)
            
            return FormatUnit(placeholder: substitutedPlaceholder, range: formatUnit.range)
        }
        
        let formatUnitComparator = KeyPathComparator(\FormatUnit.placeholder?.index)
        let sortedFormatUnits = substitutedFormatUnits.sorted(using: formatUnitComparator)
        
        return FormatInfo(substitutedFormatUnits: substitutedFormatUnits,
                          sortedFormatUnits: sortedFormatUnits)
    }
    
    private func defaultValue(from dto: StringUnitDTO, formatInfo: FormatInfo) -> String {
        let substitutedFormatUnits = formatInfo.substitutedFormatUnits
        let sortedFormatUnits = formatInfo.sortedFormatUnits
        
        if sortedFormatUnits == substitutedFormatUnits {
            var result = dto.escapedValue
            var paramIndex = substitutedFormatUnits.count(where: { $0.placeholder != nil })
            
            for formatUnit in substitutedFormatUnits.reversed() {
                switch formatUnit.specifier {
                case .percentSign:
                    result.replaceSubrange(formatUnit.range, with: "%")
                case .placeholder(let placeholder):
                    let variableName = placeholder.variableName ?? "param\(paramIndex)"
                    result.replaceSubrange(formatUnit.range, with: "\\(\(variableName))")
                    paramIndex -= 1
                }
            }
            
            return result.replacing(.newlineSequence, with: "\n")
        } else {
            let interpolations = sortedFormatUnits
                .compactMap(\.placeholder)
                .enumerated()
                .map { index, placeholder in
                    let variableName = placeholder.variableName ?? "param\(index + 1)"
                    return "\\(\(variableName))"
                }
            
            return "\(interpolations.joined(separator: " "))\n\(dto.escapedValue)"
                .replacing(.newlineSequence, with: "\n")
        }
    }
    
    private func methodParameters(from formatUnits: [FormatUnit]) -> [LocalizationItem.Parameter] {
        return formatUnits.compactMap(\.placeholder).enumerated().map { index, placeholder in
            let firstName = placeholder.variableName ?? "_"
            let secondName = placeholder.variableName == nil ? "param\(index + 1)" : nil
            let type = String(formatPlaceholder: placeholder)
            
            return LocalizationItem.Parameter(
                firstName: firstName,
                secondName: secondName,
                type: type)
        }
    }
}

private extension StringUnitDTO {
    var escapedValue: String {
        return value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
