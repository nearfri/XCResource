# XCResource
[![Swift](https://github.com/nearfri/XCResource/workflows/Swift/badge.svg)](https://github.com/nearfri/XCResource/actions?query=workflow%3ASwift)
[![Swift Version Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnearfri%2FXCResource%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/nearfri/XCResource)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnearfri%2FXCResource%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/nearfri/XCResource)
[![codecov](https://codecov.io/gh/nearfri/XCResource/branch/main/graph/badge.svg?token=DWKDFE0O2A)](https://codecov.io/gh/nearfri/XCResource)

**XCResource** is a tool that allows you to efficiently and safely manage resources (strings, fonts, files, etc.) in Xcode projects.
It reduces typos and runtime errors through automatic code generation.

## Features

### 1. Resource Code Generation
- Generates type-safe Swift code for **strings, fonts, and file resources**.

### 2. Flexible Configuration and Integration
- Supports Swift Package Manager for easy dependency management.
- Allows generating code for specific resource paths using configuration files.
- Easily executable via Swift Package Plugin.

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/nearfri/XCResource.git", from: "0.11.4"),
    // OR
    .package(url: "https://github.com/nearfri/XCResource-plugin.git", from: "0.11.4"),
],
```
Since `XCResource` includes the full source code, It is recommended to use the [`XCResource-plugin`](https://github.com/nearfri/XCResource-plugin.git) that only includes the plugin.

## Quick Start

### 1. Managing Localized Strings
https://github.com/user-attachments/assets/ce0122be-e0c5-42b6-abf6-4d1d8e0dcf4d

#### Configuration File (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "xcstrings2swift",
            "catalogPath": "Sources/Resources/Resources/Localizable.xcstrings",
            "bundle": "at-url:Bundle.module.bundleURL",
            "swiftPath": "Sources/Resources/Keys/LocalizedStringResource+.swift"
        }
    ]
}
```

#### Example of Generated Code
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

#### Example Usage
```swift
let string = String(localized: .commonDone)
```

### 2. Font Code Generation
https://github.com/user-attachments/assets/83990542-0d9a-4c12-8f3f-74c47b8fe381

#### Configuration File (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "fonts2swift",
            "resourcesPath": "Sources/Resources/Resources",
            "swiftPath": "Sources/Resources/Keys/FontResource.swift",
            "keyTypeName": "FontResource",
            "keyListName": "all",
            "generatesLatinKey": true,
            "stripsCombiningMarksFromKey": true,
            "preservesRelativePath": true,
            "bundle": "Bundle.module",
            "accessLevel": "public"
        }
    ]
}
```

#### Example of Generated Code
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

#### Example Usage
```swift
Font.custom(.openSansBold, size: 16)
```

### 3. File Code Generation

#### Configuration File (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "files2swift",
            "resourcesPath": "Sources/Resources/Resources/Lotties",
            "filePattern": "(?i)\\.json$",
            "swiftPath": "Sources/Resources/Keys/LottieResource.swift",
            "keyTypeName": "LottieResource",
            "preservesRelativePath": true,
            "relativePathPrefix": "Lotties",
            "bundle": "Bundle.module",
            "accessLevel": "public"
        }
    ]
}
```

#### Example of Generated Code
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

#### Example Usage
```swift
LottieView(.hello)
```

## Available Commands
| Command              | Description                                                  |
|----------------------|--------------------------------------------------------------|
| `xcstrings2swift`    | Parses `.xcstrings` file and generates code.                 |
| `fonts2swift`        | Scans font folder and generates code.                        |
| `files2swift`        | Scans file folder and generates code.                        |
| `xcassets2swift`     | Scans `.xcassets` folder and generates code.                 |

## License
XCResource is distributed under the MIT license. For more details, see the LICENSE file.
