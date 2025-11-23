import Foundation
import RegexBuilder
import Strix
import StrixParsers

extension StringCatalogDTOMapper {
    private struct FormatInfo {
        var formatUnits: [FormatUnit] = []
        
        var additionalFormatUnits: [FormatUnit] = []
        
        var allUniqueFormatUnits: [FormatUnit] {
            return (formatUnits + additionalFormatUnits).removingDuplicatePlaceholderIndices()
        }
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
        guard let primaryStringUnitDTO = primaryStringUnit(from: dto) else {
            throw Error.stringUnitDoesNotExist(key: key)
        }
        
        let formatInfo = try formatInfo(from: dto, primaryStringUnit: primaryStringUnitDTO)
        
        let defaultValue = try defaultValue(
            from: primaryStringUnitDTO,
            localization: dto,
            formatInfo: formatInfo
        )
        
        let methodParameters = methodParameters(
            from: formatInfo.allUniqueFormatUnits.sortedByPlaceholderIndex()
        )
        
        let memberDeclaration = if methodParameters.isEmpty {
            LocalizationItem.MemberDeclaration.property(key.toIdentifier())
        } else {
            LocalizationItem.MemberDeclaration.method(key.toIdentifier(), methodParameters)
        }
        
        return LocalizationItem(
            key: key,
            defaultValue: defaultValue,
            rawDefaultValue: primaryStringUnitDTO.escapedValue,
            memberDeclaration: memberDeclaration)
    }
    
    private func primaryStringUnit(from dto: LocalizationDTO) -> StringUnitDTO? {
        if let stringUnitDTO = dto.stringUnit {
            return stringUnitDTO
        }
        
        guard let variationsDTO = dto.variations else {
            return nil
        }
        
        switch variationsDTO {
        case .device(let deviceVariationsDTO):
            return deviceVariationsDTO.primaryStringUnit
        case .plural(let pluralVariationsDTO):
            return pluralVariationsDTO.primaryStringUnit
        }
    }
    
    private func formatInfo(
        from localization: LocalizationDTO,
        primaryStringUnit: StringUnitDTO
    ) throws -> FormatInfo {
        let substitutions = localization.substitutions
        
        var result = try formatInfo(from: primaryStringUnit, substitutions: substitutions)
        
        var additionalFormatUnits = result.additionalFormatUnits
        
        var placeholderIndices = Set(result.allUniqueFormatUnits.compactMap(\.placeholder?.index))
        
        for stringUnit in localization.allStringUnits {
            let formatInfo = try formatInfo(from: stringUnit, substitutions: substitutions)
            for formatUnit in formatInfo.allUniqueFormatUnits {
                guard let placeholderIndex = formatUnit.placeholder?.index,
                      !placeholderIndices.contains(placeholderIndex)
                else { continue }
                
                placeholderIndices.insert(placeholderIndex)
                additionalFormatUnits.append(formatUnit.with(\.range, nil))
            }
        }
        
        result.additionalFormatUnits = additionalFormatUnits.sortedByPlaceholderIndex()
        
        return result
    }
    
    private func formatInfo(
        from stringUnit: StringUnitDTO,
        substitutions: [String: SubstitutionDTO]?
    ) throws -> FormatInfo {
        let formatUnits = try formatUnitsParser.run(stringUnit.escapedValue)
        
        return try formatUnits.reduce(into: FormatInfo()) { partialResult, formatUnit in
            guard let placeholder = formatUnit.placeholder,
                  let variableName = placeholder.variableName,
                  let substitution = substitutions?[variableName]
            else {
                partialResult.formatUnits.append(formatUnit)
                return
            }
            
            let substitutedPlaceholder = try placeholder.applying(
                substitution,
                using: formatPlaceholderParser
            )
            
            let substitutedFormatUnit = FormatUnit(
                placeholder: substitutedPlaceholder,
                range: formatUnit.range
            )
            
            let additionalFormatUnits = try additionalFormatUnits(
                from: substitution,
                basePlaceholder: substitutedPlaceholder
            )
            
            partialResult.formatUnits.append(substitutedFormatUnit)
            partialResult.additionalFormatUnits.append(contentsOf: additionalFormatUnits)
        }
    }
    
    private func additionalFormatUnits(
        from substitution: SubstitutionDTO,
        basePlaceholder: FormatPlaceholder
    ) throws -> [FormatUnit] {
        return try substitution.variations.plural
            .flatMap({ _, variationValueDTO in
                try formatUnitsParser.run(variationValueDTO.stringUnit.escapedValue)
            })
            .compactMap(\.placeholder)
            .map({
                var placeholder = $0
                placeholder.index = placeholder.index ?? basePlaceholder.index
                return FormatUnit(placeholder: placeholder, range: nil)
            })
            .filter({ $0.placeholder?.index != basePlaceholder.index })
            .sortedByPlaceholderIndex()
            .removingDuplicatePlaceholderIndices()
    }
    
    private func defaultValue(
        from dto: StringUnitDTO,
        localization: LocalizationDTO,
        formatInfo: FormatInfo
    ) throws -> String {
        let template = try defaultValueTemplate(from: dto, formatInfo: formatInfo)
        
        if let template {
            var result = template
            var paramIndex = formatInfo.formatUnits.count(where: { $0.placeholder != nil })
            
            for formatUnit in formatInfo.formatUnits.reversed() {
                guard let range = formatUnit.range else { continue }
                
                switch formatUnit.specifier {
                case .percentSign:
                    result.replaceSubrange(range, with: "%")
                case .placeholder(let placeholder):
                    let index = placeholder.index ?? paramIndex
                    let interpolation = interpolation(from: placeholder, index: index)
                    result.replaceSubrange(range, with: interpolation)
                    paramIndex -= 1
                }
            }
            
            return result.replacing(.newlineSequence, with: "\n")
        } else {
            let interpolations = formatInfo
                .allUniqueFormatUnits
                .sortedByPlaceholderIndex()
                .compactMap(\.placeholder)
                .enumerated()
                .map { index, placeholder in
                    return interpolation(from: placeholder, index: index + 1)
                }
            
            let stringUnit = try stringUnitForAlternativeDefaultValue(from: localization) ?? dto
            
            return "\(interpolations.joined(separator: " "))\n\(stringUnit.escapedValue)"
                .replacing(.newlineSequence, with: "\n")
        }
    }
    
    private func defaultValueTemplate(
        from dto: StringUnitDTO,
        formatInfo: FormatInfo
    ) throws -> String? {
        let hasAdditionalFormatUnits = !formatInfo.additionalFormatUnits.isEmpty
        
        var areFormatUnitsSorted: Bool {
            let uniqueFormatUnits = formatInfo.formatUnits.removingDuplicatePlaceholderIndices()
            return uniqueFormatUnits == uniqueFormatUnits.sortedByPlaceholderIndex()
        }
        
        guard !hasAdditionalFormatUnits, areFormatUnitsSorted,
              try !containsOnlySubstitutions(in: dto)
        else { return nil }
        
        return dto.escapedValue
    }
    
    private func containsOnlySubstitutions(in dto: StringUnitDTO) throws -> Bool {
        let stringValue = dto.escapedValue
        let formatUnits = try formatUnitsParser.run(stringValue)
        let stringUnitRanges = RangeSet(stringValue.startIndex..<stringValue.endIndex)
        let substitutionRanges = RangeSet(
            formatUnits.filter({ $0.placeholder?.variableName != nil }).compactMap(\.range)
        )
        
        return substitutionRanges == stringUnitRanges
    }
    
    private func interpolation(from placeholder: FormatPlaceholder, index: Int) -> String {
        let name = placeholder.resolvedName ?? "param\(index)"
        
        let needsSpecifier: Bool = {
            if placeholder.isPluralVariable {
                return false
            }
            
            let hasFlags = !placeholder.flags.isEmpty
            let hasWidthOrPrecision = placeholder.width != nil || placeholder.precision != nil
            
            let length = placeholder.length
            let hasUsualLength = length == nil || length == .long || length == .longLong
            
            let conversion = placeholder.conversion
            let hasUsualConversion = [
                .decimal, .int, .unsigned, .float, .object
            ].contains(conversion)
            
            return hasFlags || hasWidthOrPrecision || !hasUsualLength || !hasUsualConversion
        }()
        
        if needsSpecifier {
            return "\\(\(name), specifier: \"\(placeholder.stringValueWithoutIndex)\")"
        } else {
            return "\\(\(name))"
        }
    }
    
    private func stringUnitForAlternativeDefaultValue(
        from dto: LocalizationDTO
    ) throws -> StringUnitDTO? {
        if let variations = dto.variations {
            switch variations {
            case .device(let deviceVariationsDTO):
                guard let stringUnit = deviceVariationsDTO.primaryStringUnit else { return nil }
                if try !containsOnlySubstitutions(in: stringUnit) {
                    return stringUnit
                }
            case .plural(let pluralVariationsDTO):
                return pluralVariationsDTO.primaryStringUnit
            }
        }
        
        return dto.substitutions?.values.first?.variations.primaryStringUnit
    }
    
    private func methodParameters(from formatUnits: [FormatUnit]) -> [LocalizationItem.Parameter] {
        return formatUnits.compactMap(\.placeholder).enumerated().map { index, placeholder in
            let firstName = placeholder.resolvedName ?? "_"
            let secondName = placeholder.resolvedName == nil ? "param\(index + 1)" : nil
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
        return value.escapedForStringLiteral
    }
}

private extension FormatPlaceholder {
    var stringValueWithoutIndex: String {
        var result = "%"
        
        for flag in flags {
            result.append(flag.rawValue)
        }
        
        if let width {
            result += width.stringValue
        }
        
        if let precision {
            result += "." + precision.stringValue
        }
        
        if let length {
            result += length.rawValue
        }
        
        result.append(conversion.rawValue)
        
        if let variableName {
            result += "\(variableName)@"
        }
        
        return result
    }
}

private extension FormatPlaceholder.Width {
    var stringValue: String {
        switch self {
        case .static(let value):
            return "\(value)"
        case .dynamic(let index):
            if let index {
                return "*\(index)$"
            } else {
                return "*"
            }
        }
    }
}

private extension [FormatUnit] {
    func sortedByPlaceholderIndex() -> [FormatUnit] {
        return sorted(using: KeyPathComparator(\.placeholder?.index))
    }
    
    func removingDuplicatePlaceholderIndices() -> [FormatUnit] {
        typealias PartialResult = (formatUnits: [FormatUnit], containedIndices: Set<Int>)
        
        return reduce(into: ([], []) as PartialResult) { partialResult, formatUnit in
            guard let index = formatUnit.placeholder?.index else {
                partialResult.formatUnits.append(formatUnit)
                return
            }
            
            if !partialResult.containedIndices.contains(index) {
                partialResult.formatUnits.append(formatUnit)
                partialResult.containedIndices.insert(index)
            }
        }
        .formatUnits
    }
}
