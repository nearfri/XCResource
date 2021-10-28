import Foundation
import ArgumentParser
import AssetKeyGen

extension AssetType: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(pathExtension: argument)
    }
    
    public var defaultValueDescription: String {
        return pathExtension
    }
    
    public static var allValueStrings: [String] {
        return AssetType.allCases.map(\.pathExtension)
    }
    
    static var someValueStrings: [String] {
        let someTypes: [AssetType] = [.imageSet, .colorSet, .symbolSet, .dataSet]
        return someTypes.map(\.pathExtension) + ["..."]
    }
    
    static var joinedValueStrings: String {
        return someValueStrings.joined(separator: "|")
    }
}