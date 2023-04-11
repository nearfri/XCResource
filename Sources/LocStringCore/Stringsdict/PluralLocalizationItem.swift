import Foundation
import OrderedCollections
import Strix
import StrixParsers

public struct PluralLocalizationItem: Equatable {
    public var key: String
    public var format: String
    public var variables: [String: Variable]
    
    public init(key: String, format: String, variables: [String: Variable]) {
        self.key = key
        self.format = format
        self.variables = variables
    }
}

extension PluralLocalizationItem {
    public struct Variable: Equatable {
        public var specType: String
        public var valueType: String
        public var other: String
        
        public init(specType: String, valueType: String, other: String) {
            self.specType = specType
            self.valueType = valueType
            self.other = other
        }
    }
}

extension PluralLocalizationItem {
    public init(
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
    
    public func toLocalizationItem() -> LocalizationItem {
        return LocalizationItem(key: key, value: suggestedFormat)
    }
    
    public var suggestedFormat: String {
        guard variables.count == 1, let (key, variable) = variables.first,
              format == "%#@\(key)@", variable.other.contains("%\(variable.valueType)")
        else { return format }
        
        return variable.other.replacingOccurrences(
            of: "%\(variable.valueType)",
            with: "%#@\(key)@")
    }
}
