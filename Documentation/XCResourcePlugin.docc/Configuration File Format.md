# Configuration File Format

The XCResource configuration file defines commands and options to generate resource code.

## Overview

XCResource relies on a `xcresource.json` file for configuration.
This file outlines the commands and settings used to process resources and generate Swift code.

### Example Configuration File

The configuration file is a JSON file that contains an array of commands.
Below is an example configuration:

```json
{
    "commands": [
        {
            "commandName": "xcstrings2swift",
            "catalogPath": "Sources/ExampleLib/Resources/Localizable.xcstrings",
            "bundle": "atURL:Bundle.module.bundleURL",
            "swiftCodePath": "Sources/ExampleLib/ResourceAccess/LocalizedStringResource+.swift"
        },
        {
            "commandName": "fonts2swift",
            "resourcesPath": "Sources/ExampleLib/Resources/Fonts",
            "swiftCodePath": "Sources/ExampleLib/ResourceAccess/FontResource.swift",
            "resourceTypeName": "FontResource",
            "resourceListName": "all",
            "transformsToLatin": true,
            "stripsCombiningMarks": true,
            "bundle": "Bundle.module",
            "accessLevel": "public"
        },
        {
            "commandName": "files2swift",
            "resourcesPath": "Sources/ExampleLib/Resources/Lotties",
            "filePattern": "(?i)\\.json$",
            "swiftCodePath": "Sources/ExampleLib/ResourceAccess/LottieResource.swift",
            "resourceTypeName": "LottieResource",
            "bundle": "Bundle.module",
            "accessLevel": "public"
        },
        {
            "commandName": "xcassets2swift",
            "xcassetsPaths": [
                "Sources/ExampleLib/Resources/Assets.xcassets"
            ],
            "assetTypes": ["colorset"],
            "swiftCodePath": "Sources/ExampleLib/ResourceAccess/ColorKey.swift",
            "resourceTypeName": "ColorKey",
            "accessLevel": "public"
        }
    ]
}
```

### Supported Commands and Options

Below is a list of commands you can use and the options available for each.
These commands let you control how resources are handled and how Swift code is generated.

**`xcstrings2swift`**
Option | Description
-------|------------
`catalogPath` | The path to the `.xcstrings` file.
`bundle` | Specifies the bundle containing the strings file. Possible values: `main`, `atURL:<url-getter>` or `forClass:<class-type>`. Default: `main`.
`swiftCodePath` | The path where the generated Swift file will be saved.
`resourceTypeName` | The name of the generated resource type. Default: `LocalizedStringResource`.

---

**`fonts2swift`**
Option | Description
-------|------------
`resourcesPath` | The path to the folder containing font resources.
`swiftCodePath` | The path where the generated Swift file will be saved.
`resourceTypeName` | The name of the generated font resource type.
`resourceListName` | The name of the list containing all font resources.
`transformsToLatin` | Whether to transform font identifiers to Latin characters. Default: `false`.
`stripsCombiningMarks` | Whether to strip combining marks from font identifiers. Default: `false`.
`preservesRelativePath` | Whether to preserve relative paths. Set to `false` if using the [*process rule*](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#Explicitly-declare-or-exclude-resources). Default: `true`.
`relativePathPrefix` | A prefix to prepend to relative paths. Default: `null`.
`bundle` | Specifies the bundle containing the font resources. Default: `Bundle.main`.
`accessLevel` | The access level for the generated code. Default: `null`.
`excludesTypeDeclaration` | Whether to exclude the type declaration in the generated code. Default: `false`.

---

**`files2swift`**
Option | Description
-------|------------
`resourcesPath` | The path to the folder containing resource files.
`filePattern` | A regex pattern to match files.
`swiftCodePath` | The path where the generated Swift file will be saved.
`resourceTypeName` | The name of the generated resource type.
`preservesRelativePath` | Whether to preserve relative paths. Set to `false` if using the [*process rule*](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#Explicitly-declare-or-exclude-resources). Default: `true`.
`relativePathPrefix` | A prefix to prepend to relative paths. Default: `null`.
`bundle` | Specifies the bundle containing the resource files. Default: `Bundle.main`.
`accessLevel` | The access level for the generated code. Default: `null`.
`excludesTypeDeclaration` | Whether to exclude the type declaration in the generated code. Default: `false`.

---

**`xcassets2swift`**
Option | Description
-------|------------
`xcassetsPaths` | An array of paths to `.xcassets` directories.
`assetTypes` | An array of asset types to include, e.g., `imageset`, `colorset`, `symbolset`, `dataset`. If empty, all types are included by default.
`swiftCodePath` | The path where the generated Swift file will be saved.
`resourceTypeName` | The name of the generated resource type.
`accessLevel` | The access level for the generated code. Default: `null`.
`excludesTypeDeclaration` | Whether to exclude the type declaration in the generated code. Default: `false`.
