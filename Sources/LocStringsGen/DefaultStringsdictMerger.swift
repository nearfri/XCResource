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
        guard let comment = item.comment else { preconditionFailure() }
        
        let variableNames = try pluralVariableNamesParser.run(comment)
        
        let info: PlistDictionary = variableNames
            .reduce(into: [StringsdictKey.format: .string(comment)]) { partialResult, name in
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
        guard let comment = item.comment else { preconditionFailure() }
        
        return .dictionary([
            StringsdictKey.deviceRuleType: .dictionary([
                "iphone": .string(comment),
                "mac": .string(comment),
                "appletv": .string(comment),
            ])
        ])
    }
}
