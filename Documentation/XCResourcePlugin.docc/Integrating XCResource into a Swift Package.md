# Integrating XCResource into a Swift Package

Integrate the XCResource plugin into a Swift Package to automate Swift code generation.

## Overview

This guide provides a step-by-step process for integrating and using the XCResource plugin in your Swift Package.

### Add XCResource to Your Package

To include XCResource in your Swift Package, update the `Package.swift` file by adding the following dependency:

```swift
dependencies: [
    .package(url: "https://github.com/nearfri/XCResource-plugin.git", from: "<version>"),
],
```

> Use [XCResource-plugin](https://github.com/nearfri/XCResource-plugin.git) instead of [XCResource](https://github.com/nearfri/XCResource.git) to leverage the precompiled binary executable.

### Configure XCResource

Create an `xcresource.json` file in your package.
This configuration file is read by the XCResource plugin and serves as the blueprint for generating Swift resource code.

The plugin supports the following configuration file locations:

- `${PACKAGE_DIR}/xcresource.json`
- `${PACKAGE_DIR}/.xcresource.json`
- `${PACKAGE_DIR}/Configs/xcresource.json`
- `${PACKAGE_DIR}/Scripts/xcresource.json`

Start with a minimal configuration by defining an empty `commands` array:

```json
{
    "commands": [

    ]
}
```

In future steps, the `commands` array will be populated with specific commands that define how XCResource processes your resources.

### Execute the XCResource Plugin

Follow these steps to run the XCResource plugin and generate resource code:

1. In the **Project navigator**, right-click your package and select **Generate Resource Code** from the context menu.

![XCResource plugin run step1](plugin-run-1)

2. In the presented dialog, click **Run**.

![XCResource plugin run step2](plugin-run-2)

3. When prompted, click **Allow Command to Change Files** to grant the plugin permission to modify files in your package.

![XCResource plugin run step3](plugin-run-3)

4. Open the **Reports navigator** to verify that the plugin executed successfully. Check the logs for any errors or warnings.

![XCResource plugin run step4](plugin-run-4)

With the XCResource plugin successfully integrated, you’re now ready to define resource commands and generate Swift code to suit your needs.
