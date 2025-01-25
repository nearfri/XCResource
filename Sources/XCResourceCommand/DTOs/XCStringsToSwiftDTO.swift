import Foundation
import ArgumentParser
import LocStringResourceGen

struct XCStringsToSwiftDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = XCStringsToSwift.self
    
    var catalogPath: String
    var bundle: String?
    var swiftFilePath: String
    var resourceTypeName: String?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = XCStringsToSwift.Default
        
        let bundle = try self.bundle.map({
            guard let bundle = LocalizationItem.BundleDescription(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.bundle.stringValue,
                    value: $0,
                    valueDescription: LocalizationItem.BundleDescription.joinedAllValuesString)
            }
            return bundle
        })
        
        var command = XCStringsToSwift()
        command.catalogPath = catalogPath
        command.bundle = bundle ?? Default.bundle
        command.swiftFilePath = swiftFilePath
        command.resourceTypeName = resourceTypeName ?? Default.resourceTypeName
        
        return command
    }
}
