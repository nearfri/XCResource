# XCResource
[![Swift](https://github.com/nearfri/XCResource/workflows/Swift/badge.svg)](https://github.com/nearfri/XCResource/actions?query=workflow%3ASwift)
[![Swift Version Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnearfri%2FXCResource%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/nearfri/XCResource)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnearfri%2FXCResource%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/nearfri/XCResource)
[![codecov](https://codecov.io/gh/nearfri/XCResource/branch/main/graph/badge.svg?token=DWKDFE0O2A)](https://codecov.io/gh/nearfri/XCResource)

**XCResource** is a tool that allows you to efficiently and safely manage resources (localized strings, fonts, and other files) in Xcode projects.
By automating code generation, it reduces typos and runtime errors.

## Features

### 1. Type-Safe Resource Code Generation
- Generates type-safe Swift code for **localized strings, fonts, and other files**.

### 2. Flexible Configuration and Integration
- Supports Swift Package Manager for easy integration.
- Enables customized code generation using configuration files.
- Easily executable via Swift Package Plugin.

## Getting Started

### 1. Adding `XCResource` to Your Project

### Add to `Package.swift`
```swift
dependencies: [
    .package(url: "https://github.com/nearfri/XCResource.git", from: "<version>"),
    // OR
    .package(url: "https://github.com/nearfri/XCResource-plugin.git", from: "<version>"),
],
```
**Recommendation**: Use [XCResource-plugin](https://github.com/nearfri/XCResource-plugin.git) to take advantage of the precompiled binary executable.

### Create a Configuration File (`xcresource.json`)
Add an `xcresource.json` file to your project. The plugin reads this file and generates Swift code every time it runs.

Supported paths for the configuration file:
- `${PROJECT_DIR}/xcresource.json`
- `${PROJECT_DIR}/.xcresource.json`
- `${PROJECT_DIR}/Configs/xcresource.json`
- `${PROJECT_DIR}/Scripts/xcresource.json`

### 2. Managing Localized Strings
`xcresource` provides multiple subcommands. Among them, `xcstrings2swift` parses a String Catalog (.xcstrings) and generates [LocalizedStringResource](https://developer.apple.com/documentation/foundation/localizedstringresource) constants.

https://github.com/user-attachments/assets/16073e8f-9ad9-4e9c-b945-d542efd656f7

#### Configuration (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "xcstrings2swift",
            "catalogPath": "Sources/Resources/Resources/Localizable.xcstrings",
            "bundle": ".atURL(Bundle.module.bundleURL)",
            "swiftFilePath": "Sources/Resources/ResourceAccess/LocalizedStringResource+.swift"
        }
    ]
}
```

#### Generated Code
```swift
public extension LocalizedStringResource {
    /// \"\\(param1)\" will be deleted.\
    /// This action cannot be undone.
    static func alertDeleteFile(_ param1: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                \"\(param1)\" will be deleted.
                This action cannot be undone.
                """,
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Done
    static var commonDone: Self {
        .init("common_done",
              defaultValue: "Done",
              bundle: .atURL(Bundle.module.bundleURL))
    }
}
```
*(Function names and parameter names can be customized if they match the localization key and function signature.)*

#### Usage
```swift
Text(.commonDone)
```

### 3. Font Code Generation
`fonts2swift` generates Swift code for fonts.

https://github.com/user-attachments/assets/ae09a571-3ee8-450e-84c2-39341fe203d2

#### Configuration (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "fonts2swift",
            "resourcesPath": "Sources/Resources/Resources",
            "swiftFilePath": "Sources/Resources/ResourceAccess/FontResource.swift",
            "resourceTypeName": "FontResource",
            "resourceListName": "all",
            "transformsToLatin": true,
            "stripsCombiningMarks": true,
            "preservesRelativePath": true,
            "bundle": "Bundle.module",
            "accessLevel": "public"
        }
    ]
}
```

#### Generated Code
```swift
public struct FontResource: Hashable, Sendable {
    public let fontName: String
    public let familyName: String
    public let style: String
    public let relativePath: String
    public let bundle: Bundle
    ...
}

public extension FontResource {
    static let all: [FontResource] = [
        // Cambria
        .cambriaRegular,
        
        // Open Sans
        .openSansBold,
    ]
}

public extension FontResource {
    // MARK: Cambria
    
    static let cambriaRegular: FontResource = .init(
        fontName: "Cambria",
        familyName: "Cambria",
        style: "Regular",
        relativePath: "Fonts/Cambria.ttc",
        bundle: Bundle.module)
    
    // MARK: Open Sans
    
    static let openSansBold: FontResource = .init(
        fontName: "OpenSans-Bold",
        familyName: "Open Sans",
        style: "Bold",
        relativePath: "Fonts/OpenSans/OpenSans-Bold.ttf",
        bundle: Bundle.module)
}
```

#### Usage
```swift
Font.custom(.openSansBold, size: 16)
```

### 4. File Code Generation
`files2swift` generates Swift code for files such as JSON.

#### Configuration (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "files2swift",
            "resourcesPath": "Sources/Resources/Resources/Lotties",
            "filePattern": "(?i)\\.json$",
            "swiftFilePath": "Sources/Resources/ResourceAccess/LottieResource.swift",
            "resourceTypeName": "LottieResource",
            "preservesRelativePath": true,
            "relativePathPrefix": "Lotties",
            "bundle": "Bundle.module",
            "accessLevel": "public"
        }
    ]
}
```

#### Generated Code
```swift
public struct LottieResource: Hashable, Sendable {
    public let relativePath: String
    public let bundle: Bundle
    ...
}

extension LottieResource {
    public static let hello: LottieResource = .init(
        relativePath: "Lotties/hello.json",
        bundle: Bundle.module)
}
```

#### Usage
```swift
LottieView(.hello)
```

## Commands
| Command              | Description                                                  |
|----------------------|--------------------------------------------------------------|
| `xcstrings2swift`    | Scans `.xcstrings` file and generates code.                  |
| `fonts2swift`        | Scans font directory and generates code.                     |
| `files2swift`        | Scans directory for matching files and generates code.       |
| `xcassets2swift`     | Scans `.xcassets` directory and generates code.              |

## Documentation
For more information about the plugin, check the documentation on Swift Package Index.
  - [XCResource Documentation](https://swiftpackageindex.com/nearfri/xcresource/documentation/documentation)
  - Getting Started
    - [Integrating XCResource into a Swift Package](https://swiftpackageindex.com/nearfri/xcresource/documentation/documentation/integrating-xcresource-into-a-swift-package)
    - [Generating LocalizedStringResource](https://swiftpackageindex.com/nearfri/xcresource/documentation/documentation/generating-localizedstringresource)
    - [Generating FontResource](https://swiftpackageindex.com/nearfri/xcresource/documentation/documentation/generating-fontresource)
  - Advanced
    - [Configuration File Format](https://swiftpackageindex.com/nearfri/xcresource/documentation/documentation/configuration-file-format)

### Example
This repository includes an [example](https://github.com/nearfri/XCResource/tree/main/Examples) of using the plugin.

## License
XCResource is distributed under the MIT license. For more details, see the LICENSE file.
