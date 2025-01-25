import Foundation
import ArgumentParser
import LocStringsGen

extension Config {
    struct Init: ParsableCommand {
        static let configuration: CommandConfiguration = .init(
            commandName: "init",
            abstract: "Create an initial configuration file")
        
        // MARK: - Run
        
        mutating func run() throws {
            let fileURL = URL(fileURLWithPath: Run.Default.configurationPath)
            
            print("Creating configuration file: \(fileURL.lastPathComponent)")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                throw Error.configurationAlreadyExists
            }
            
            try configurationTemplate.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}

extension Config.Init {
    private enum Error: LocalizedError {
        case configurationAlreadyExists
        
        var errorDescription: String? {
            switch self {
            case .configurationAlreadyExists:
                return "The configuration file already exists in this directory"
            }
        }
    }
}

private let configurationTemplate = """
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
            "resourceTypeName": "<#resource type name#>",
            "accessLevel": null,
            "excludesTypeDeclaration": false
        },
        {
            "commandName": "files2swift",
            "resourcesPath": "<#resourcesPath#>",
            "filePattern": "<#(?i)\\.(jpeg|jpg)$#>",
            "swiftPath": "<#swift file path#>",
            "resourceTypeName": "<#resource type name#>",
            "bundle": "<#Bundle.main#>",
            "accessLevel": null,
            "excludesTypeDeclaration": false
        },
        {
            "commandName": "fonts2swift",
            "resourcesPath": "<#resourcesPath#>",
            "swiftPath": "<#swift file path#>",
            "resourceTypeName": "<#resource type name#>",
            "resourceListName": null,
            "transformsToLatin": false,
            "stripsCombiningMarks": false,
            "preservesRelativePath": true,
            "relativePathPrefix": null,
            "bundle": "<#Bundle.main#>",
            "accessLevel": null,
            "excludesTypeDeclaration": false
        },
        {
            "commandName": "xcstrings2swift",
            "catalogPath": "<#xcstrings file path#>",
            "bundle": "<#main|at-url<url-getter>|for-class<class-type>#>",
            "swiftPath": "<#swift file path#>",
            "resourceTypeName": "LocalizedStringResource"
        },
        {
            "commandName": "key2form",
            "keyFilePath": "<#key file path#>",
            "formFilePath": "<#form file path#>",
            "formTypeName": "<#form type name#>",
            "accessLevel": null,
            "excludesTypeDeclaration": false,
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
            "commandName": "swift2stringsdict",
            "swiftPath": "<#swift file path#>",
            "resourcesPath": "<#resources path#>",
            "tableName": "Localizable",
            "configurationsByLanguage": {
                "<#language#>": {
                    "mergeStrategy": "<#comment|key|custom-string|dont-add#>"
                }
            },
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
            "commandName": "stringsdict2swift",
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
