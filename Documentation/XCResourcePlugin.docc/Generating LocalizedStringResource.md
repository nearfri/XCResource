# Generating LocalizedStringResource

Generate `LocalizedStringResource` constants for localized strings in a Swift Package.

## Overview

This guide explains the process of generating `LocalizedStringResource` constants in a Swift Package using XCResource.
It includes preparing the Strings Catalog file, configuring and running the plugin,
customizing the generated code, and addressing common issues during code generation.

### Prepare the Strings Catalog File

Ensure the keys in the Strings Catalog file follow camelCase or snake_case conventions.
Keys in snake_case will be automatically converted to camelCase.
For example, `alert_delete_file` will become `alertDeleteFile` in the generated Swift code.

![xcstrings step1](xcstrings-1)

### Set Up a Folder for Generated Code

Create a folder to save the extension file for `LocalizedStringResource`.
In this example, we will create a folder named `ResourceAccess`.

![xcstrings step2](xcstrings-2)

### Configure xcresource.json

In the `xcresource.json` file, include the `xcstrings2swift` command to specify the path to the Strings Catalog file and the location for the generated Swift code.

```json
{
    "commands": [
        {
            "commandName": "xcstrings2swift",
            "catalogPath": "Sources/ExampleLib/Resources/Localizable.xcstrings",
            "bundle": "atURL:Bundle.module.bundleURL",
            "swiftFilePath": "Sources/ExampleLib/ResourceAccess/LocalizedStringResource+.swift"
        }
    ]
}
```

### Run the XCResource Plugin

In the **Project Navigator**, select the package, right-click, and choose **Generate Resource Code** from the context menu.
After the resource code is generated, open the `LocalizedStringResource+.swift` file to review the output.

![xcstrings step4](xcstrings-3)

### Rename Parameters for Clarity

When a localized string includes a format specifier such as `%@`,
XCResource automatically generates a function with a parameter for the placeholder. For example:

```swift
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
```

Parameters can be renamed for better clarity, and these changes will persist even if the plugin is rerun.

```swift
/// \"\\(filename)\" will be deleted.\
/// This action cannot be undone.
static func alertDeleteFile(named filename: String) -> Self {
    .init("alert_delete_file",
          defaultValue: """
            \"\(filename)\" will be deleted.
            This action cannot be undone.
            """,
          bundle: .atURL(Bundle.module.bundleURL))
}
```

Function names can also be modified as needed.

### Utilize String Interpolation

XCResource supports [`String.LocalizationValue.StringInterpolation`](https://developer.apple.com/documentation/swift/string/localizationvalue/stringinterpolation) features. For instance:

```swift
// Generated code

/// Hello, \\(param1).
static func greeting(_ param1: String) -> Self {
    .init("greeting",
          defaultValue: "Hello, \(param1).",
          bundle: .atURL(Bundle.module.bundleURL))
}

// You can convert a String to an AttributedString,
// and it will remain unchanged after rerunning the plugin.

/// Hello, \\(attributedName).
static func greeting(attributedName: AttributedString) -> Self {
    .init("greeting",
          defaultValue: "Hello, \(attributedName).",
          bundle: .atURL(Bundle.module.bundleURL))
}
```

```swift
// Generated code

/// The total price is \\(param1).
static func price(_ param1: String) -> Self {
    .init("price",
          defaultValue: "The total price is \(param1).",
          bundle: .atURL(Bundle.module.bundleURL))
}

// FormatStyle can also be applied

/// The total price is \\(price, format: .currency(code: currencyCode)).
static func price(_ price: Double, currencyCode: String) -> Self {
    .init("price",
          defaultValue: "The total price is \(price, format: .currency(code: currencyCode)).",
          bundle: .atURL(Bundle.module.bundleURL))
}
```

## Troubleshooting

### Ignoring Format Specifiers

In some cases, you might want format specifiers like `%lf` to stay as literal text instead of being replaced by a parameter.

![xcstrings verbatim](xcstrings-4)

By default, XCResource generates a function that treats the specifier as a placeholder.

```swift
/// \\(param1) works for doubles when formatting.
static func doubleFormat(_ param1: Double) -> Self {
    .init("double_format",
          defaultValue: "\(param1) works for doubles when formatting.",
          bundle: .atURL(Bundle.module.bundleURL))
}
```

To keep the specifier unchanged, use the `xcresource:verbatim` comment directive.

```swift
// xcresource:verbatim
/// \\(param1) works for doubles when formatting.
static func doubleFormat(_ param1: Double) -> Self {
    .init("double_format",
          defaultValue: "\(param1) works for doubles when formatting.",
          bundle: .atURL(Bundle.module.bundleURL))
}
```

After rerunning the plugin, the code will be updated as follows:

```swift
// xcresource:verbatim
/// %lf works for doubles when formatting.
static var doubleFormat: Self {
    .init("double_format",
          defaultValue: "%lf works for doubles when formatting.",
          bundle: .atURL(Bundle.module.bundleURL))
}
```
