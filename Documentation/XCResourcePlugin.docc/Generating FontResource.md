# Generating FontResource

Generate `FontResource` constants for fonts in a Swift Package.

## Overview

This guide explains the process of generating `FontResource` constants in a Swift Package using XCResource.
Steps include preparing font files, configuring the plugin, and integrating generated constants into the package.

### Prepare the Fonts

Ensure that the font files are included within the package.

![fonts step1](fonts-1)

### Update Package.swift

Add the font folder path to the `resources` array of the desired `target` in the `Package.swift` file.
This ensures the folder is included during the build process.

While it is possible to use [`process(_:localization:)`](https://developer.apple.com/documentation/PackageDescription/Resource/process(_:localization:)),
this guide uses [`copy(_:)`](https://developer.apple.com/documentation/PackageDescription/Resource/copy(_:)).

![fonts step2](fonts-2)

### Configure xcresource.json

Update the `xcresource.json` file to include the `xcfonts2swift` command for generating Swift code for the fonts.

```json
{
    "commands": [
        {
            "commandName": "fonts2swift",
            "resourcesPath": "Sources/ExampleLib/Resources",
            "swiftFilePath": "Sources/ExampleLib/ResourceAccess/FontResource.swift",
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

> If fonts were added using [`process(_:localization:)`](https://developer.apple.com/documentation/PackageDescription/Resource/process(_:localization:)), set `preservesRelativePath` to `false`.

### Run the XCResource Plugin

In the **Project Navigator**, select the package, right-click and choose **Generate Resource Code** from the context menu.
After generation, open the `FontResource.swift` file to review the generated code.

![fonts step3](fonts-3)

### Declare a FontRegistry

Declare a `FontRegistry` class to ensure proper registration of fonts before usage.

```swift
import Foundation
import CoreText

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
private typealias NativeFont = UIFont
#elseif os(macOS)
import AppKit.NSFont
private typealias NativeFont = NSFont
#endif

public final class FontRegistry: Sendable {
    private init() {}
    
    public static let shared: FontRegistry = .init()
    
    public func hasRegisteredFont(for resource: FontResource) -> Bool {
        return NativeFont(name: resource.fontName, size: 10) != nil
    }
    
    public func registerAllFonts() {
        for fontResource in FontResource.all {
            registerFont(with: fontResource)
        }
    }
    
    public func registerFontFamilyIfNeeded(for resource: FontResource) {
        if !hasRegisteredFont(for: resource) {
            registerFontFamily(name: resource.familyName)
        }
    }
    
    public func registerFontFamily(name familyName: String) {
        let fontResources = FontResource.all.filter({ $0.familyName == familyName })
        
        for fontResource in fontResources {
            registerFont(with: fontResource)
        }
    }
    
    private func registerFont(with fontResource: FontResource) {
        do {
            let fontURL = fontResource.url as CFURL
            var errRef: Unmanaged<CFError>?
            let isRegistered = CTFontManagerRegisterFontsForURL(fontURL, .process, &errRef)
            let error = errRef?.takeUnretainedValue() as Error?
            let isIgnorable = error.map(isIgnorableError(_:)) ?? false
            
            if !isRegistered && !isIgnorable {
                throw FontError.registrationFailed(path: fontResource.relativePath, error: error)
            }
        } catch {
            preconditionFailure("\(error)")
        }
    }
    
    private func isIgnorableError(_ error: Error) -> Bool {
        let nsError = error as NSError
        
        if nsError.domain != (kCTFontManagerErrorDomain as String) {
            return false
        }
        
        switch CTFontManagerError(rawValue: nsError.code) {
        case .alreadyRegistered, .duplicatedName:
            return true
        default:
            return false
        }
    }
}

extension FontRegistry {
    private enum FontError: Error {
        case registrationFailed(path: String, error: Error?)
    }
}
```

### Declare a Font Extension for FontResource

Extend the `Font` struct to support `FontResource`.

```swift
import SwiftUI

public extension Font {
    static func custom(_ resource: FontResource, fixedSize: CGFloat) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: resource)
        
        return custom(resource.fontName, fixedSize: fixedSize)
    }
    
    static func custom(
        _ resource: FontResource,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle
    ) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: resource)
        
        return custom(resource.fontName, size: size, relativeTo: textStyle)
    }
    
    static func custom(_ resource: FontResource, size: CGFloat) -> Font {
        FontRegistry.shared.registerFontFamilyIfNeeded(for: resource)
        
        return custom(resource.fontName, size: size)
    }
}
```

### Apply the Font

Fonts can be used in views as follows:

```swift
Text(verbatim: "Hello World!")
    .font(.custom(.openSansRegular, size: 32))
    .italic(true)
```
