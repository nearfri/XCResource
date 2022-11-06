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
            "accessLevel": null,
            "excludesTypeDeclation": false
        },
        {
            "commandName": "key2form",
            "keyFilePath": "<#key file path#>",
            "formFilePath": "<#form file path#>",
            "formTypeName": "<#form type name#>",
            "accessLevel": null,
            "excludesTypeDeclation": false,
            "issueReporter": "<#none|xcode#>"
        },
        {
            "commandName": "swift2strings",
            "swiftPath": "<#swift file path#>",
            "resourcesPath": "<#resources path#>",
            "tableName": "Localizable",
            "configurationsByLanguage": {
                "<#language#>": {
                    "mergeStrategy": "<#comment|key|custom-string|dont-add#>",
                    "verifiesComments": false
                }
            },
            "omitsComments": false,
            "sortsByKey": false
        },
        {
            "commandName": "strings2swift",
            "resourcesPath": "<#resources path#>",
            "tableName": "Localizable",
            "language": "en",
            "swiftPath": "<#swift file path#>"
        },
        {
            "commandName": "strings2csv",
            "resourcesPath": "<#resources path#>",
            "tableName": "Localizable",
            "developmentLanguage": "en",
            "csvPath": "<#CSV file path#>",
            "headerStyle": "<#short|long|long-<language>#>",
            "emptyEncoding": "<#string used to represent empty value#>",
            "writesBOM": false
        },
        {
            "commandName": "csv2strings",
            "csvPath": "<#CSV file path#>",
            "headerStyle": "<#short|long|long-<language>#>",
            "resourcesPath": "<#resources path#>",
            "tableName": "Localizable",
            "emptyEncoding": "<#string used to represent empty value#>"
        }
    ]
}

"""
