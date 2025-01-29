import Foundation
import ArgumentParser

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
            "swiftFilePath": "<#swift file path#>",
            "resourceTypeName": "<#resource type name#>",
            "accessLevel": null,
            "excludesTypeDeclaration": false
        },
        {
            "commandName": "files2swift",
            "resourcesPath": "<#resourcesPath#>",
            "filePattern": "<#(?i)\\.(jpeg|jpg)$#>",
            "swiftFilePath": "<#swift file path#>",
            "resourceTypeName": "<#resource type name#>",
            "bundle": "<#Bundle.main#>",
            "accessLevel": null,
            "excludesTypeDeclaration": false
        },
        {
            "commandName": "fonts2swift",
            "resourcesPath": "<#resourcesPath#>",
            "swiftFilePath": "<#swift file path#>",
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
            "bundle": "<#main|atURL:<url-getter>|forClass:<class-type>#>",
            "swiftFilePath": "<#swift file path#>",
            "resourceTypeName": "LocalizedStringResource"
        }
    ]
}

"""
