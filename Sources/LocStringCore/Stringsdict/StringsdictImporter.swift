import Foundation
import OrderedCollections
import Strix
import StrixParsers

public class StringsdictImporter: LocalizationItemImporter {
    private let pluralVariableNamesParser: Parser<[String]> = .pluralVariableNames
    
    public init() {}
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        let xmlDocument = try XMLDocument(contentsOf: url)
        let plist = try Plist(xmlDocument: xmlDocument)
        
        guard let entries = plist.dictionaryValue else {
            throw StringsdictFileError.typeMismatch(expected: "dictionary", actual: plist)
        }
        
        return try entries.compactMap { key, value in
            guard let info = value.dictionaryValue else {
                throw StringsdictFileError.typeMismatch(expected: "dictionary", actual: value)
            }
            return try makeLocalizationItem(key: key, info: info)
        }
    }
    
    private func makeLocalizationItem(
        key: String,
        info: PlistDictionary
    ) throws -> LocalizationItem? {
        if info.keys.contains(StringsdictKey.format) {
            let parser = pluralVariableNamesParser
            let item = try PluralLocalizationItem(key: key, info: info, variablesUsing: parser)
            return item.toLocalizationItem()
        } else if info.keys.contains(StringsdictKey.widthRuleType) {
            return try VariableWidthRule(key: key, info: info).toLocalizationItem()
        } else if info.keys.contains(StringsdictKey.deviceRuleType) {
            return try DeviceSpecificRule(key: key, info: info).toLocalizationItem()
        } else {
            assertionFailure("Unknown entry found. key: \(key)")
            return nil
        }
    }
}

public enum StringsdictFileError: Error {
    case typeMismatch(expected: String, actual: Plist)
}
