import Foundation
import ArgumentParser
import AssetKeyGen

extension AssetType: ExpressibleByArgument {
    public init?(argument: String) {
        switch argument {
        case "image":   self = .imageSet
        case "color":   self = .colorSet
        case "symbol":  self = .symbolSet
        default:        return nil
        }
    }
    
    public var defaultValueDescription: String {
        return "image"
    }
    
    public static var allValueStrings: [String] {
        return ["image", "color", "symbol"]
    }
}
