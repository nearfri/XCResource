import Foundation
import OrderedCollections
import Strix
import LocStringCore

class DefaultStringsdictMerger: StringsdictMerger {
    private let pluralVariableNamesParser: Parser<[String]> = .pluralVariableNames
    
    func plistByMerging(localizationItems: [LocalizationItem], plist: Plist) throws -> Plist {
        guard let oldEntries = plist.dictionaryValue else {
            throw StringsdictFileError.typeMismatch(expected: "dictionary", actual: plist)
        }
        
        let newEntries: PlistDictionary = try localizationItems
            .reduce(into: [:]) { partialResult, item in
                partialResult[item.key] = try oldEntries[item.key] ?? makePlist(item: item)
            }
        
        return .dictionary(newEntries)
    }
    
    private func makePlist(item: LocalizationItem) throws -> Plist {
        if item.commentContainsPluralVariables {
            return try makePluralFormatPlist(item: item)
        } else {
            return makeDeviceSpecificRulePlist(item: item)
        }
    }
    
    private func makePluralFormatPlist(item: LocalizationItem) throws -> Plist {
        let variableNames = try pluralVariableNamesParser.run(item.value)
        
        let info: PlistDictionary = variableNames
            .reduce(into: [StringsdictKey.format: .string(item.value)]) { partialResult, name in
                partialResult[name] = .dictionary([
                    StringsdictKey.Plural.specType: .string(StringsdictKey.Plural.ruleType),
                    StringsdictKey.Plural.valueType: .string("ld"),
                    StringsdictKey.Plural.categoryZero: .string("no"),
                    StringsdictKey.Plural.categoryOne: .string("one"),
                    StringsdictKey.Plural.categoryOther: .string("%ld"),
                ])
            }
        
        return .dictionary(info)
    }
    
    private func makeDeviceSpecificRulePlist(item: LocalizationItem) -> Plist {
        return .dictionary([
            StringsdictKey.deviceRuleType: .dictionary([
                "iphone": .string(item.value),
                "mac": .string(item.value),
                "appletv": .string(item.value),
            ])
        ])
    }
}
