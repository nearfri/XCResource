import Foundation
import OrderedCollections
import Strix
import StrixParsers

struct PluralLocalizationItem: Equatable {
    var key: String
    var format: String
    var variables: [String: Variable]
    
    init(key: String, format: String, variables: [String: Variable]) {
        self.key = key
        self.format = format
        self.variables = variables
    }
}

extension PluralLocalizationItem {
    struct Variable: Equatable {
        var specType: String
        var valueType: String
        var other: String
        
        init(specType: String, valueType: String, other: String) {
            self.specType = specType
            self.valueType = valueType
            self.other = other
        }
    }
}

extension PluralLocalizationItem {
    init(
        key: String,
        info: PlistDictionary,
        variablesUsing variableNamesParser: Parser<[String]>
    ) throws {
        let format = try info.value(forKey: StringsdictKey.format, type: String.self)
        let variableNames = try variableNamesParser.run(format)
        
        self.key = key
        self.format = format
        self.variables = try Self.makeVariables(names: variableNames, info: info)
    }
    
    private static func makeVariables(
        names: [String],
        info: PlistDictionary
    ) throws -> [String: Variable] {
        typealias PluralKey = StringsdictKey.Plural
        
        return try names.reduce(into: [:]) { partialResult, name in
            let variableInfo = try info.value(forKey: name, type: PlistDictionary.self)
            
            let specType = try variableInfo.value(forKey: PluralKey.specType, type: String.self)
            let valueType = try variableInfo.value(forKey: PluralKey.valueType, type: String.self)
            let other = try variableInfo.value(forKey: PluralKey.categoryOther, type: String.self)
            
            let variable = Variable(specType: specType, valueType: valueType, other: other)
            partialResult[name] = variable
        }
    }
    
    func toLocalizationItem() -> LocalizationItem {
        return LocalizationItem(key: key, value: suggestedFormat)
    }
    
    var suggestedFormat: String {
        guard variables.count == 1, let (key, variable) = variables.first,
              format == "%#@\(key)@", variable.other.contains("%\(variable.valueType)")
        else { return format }
        
        return variable.other.replacingOccurrences(
            of: "%\(variable.valueType)",
            with: "%#@\(key)@")
    }
}
