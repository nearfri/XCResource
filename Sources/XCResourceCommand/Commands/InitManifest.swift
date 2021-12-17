import Foundation
import ArgumentParser
import LocStringGen

struct InitManifest: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "init",
        abstract: "Create an initial manifest file")
    
    // MARK: - Run
    
    mutating func run() throws {
        let fileURL = URL(fileURLWithPath: RunManifest.Default.manifestPath)
        
        print("Creating manifest file: \(fileURL.lastPathComponent)")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            throw Error.manifestAlreadyExists
        }
        
        try manifestTemplate.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

extension InitManifest {
    private enum Error: LocalizedError {
        case manifestAlreadyExists
        
        var errorDescription: String? {
            switch self {
            case .manifestAlreadyExists:
                return "A manifest file already exists in this directory"
            }
        }
    }
}

private let manifestTemplate = """
{
    "commands": [
        {
            "commandName": "xcassets2swift",
            "xcassetsPaths": [
                "<#xcassets path#>"
            ],
            "assetTypes": [
                "<#imageset|colorset|symbolset|dataset|...#>",
                "<#If not specified, all asset types are exported.#>"
            ],
            "swiftPath": "<#swift file path#>",
            "swiftTypeName": "<#swift type name#>",
            "excludesTypeDeclation": false
        },
        {
            "commandName": "key2form",
            "keyFilePath": "<#key file path#>",
            "formFilePath": "<#form file path#>",
            "formTypeName": "<#form type name#>",
            "excludesTypeDeclation": false,
            "issueReporter": "<#none|xcode#>"
        },
        {
            "commandName": "swift2strings",
            "swiftPath": "<#swift file path#>",
            "resourcesPath": "<#resources path#>",
            "tableName": "Localizable",
            "mergeStrategies": [
                {
                    "language": "<#language#>",
                    "strategy": "<#comment|key|custom-string|dont-add#>"
                }
                <#Value strategies by language to convert.#>
                <#If "\(LanguageID.allSymbol)" is specified, all languages are converted.#>
            ],
            "shouldCompareComments": false
            "sortsByKey": false
        }
    ]
}

"""
