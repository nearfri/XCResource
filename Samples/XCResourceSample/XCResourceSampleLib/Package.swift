// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCResourceSampleLib",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macCatalyst(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "XCResourceSampleLib",
            targets: ["View", "Resource"]),
        .plugin(
            name: "StringsToSwiftPlugin",
            targets: ["StringsToSwiftPlugin"]),
        .plugin(
            name: "StringsToCSVPlugin",
            targets: ["StringsToCSVPlugin"]),
        .plugin(
            name: "CSVToStringsPlugin",
            targets: ["CSVToStringsPlugin"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // MARK: - View
        
        .target(
            name: "View",
            dependencies: ["Resource"]),
        
        // MARK: - Resource
        
        .target(
            name: "Resource",
            dependencies: [],
            resources: [.copy("Resources/Fonts")],
            plugins: [.plugin(name: "XCResourcePlugin")]),
        
        .testTarget(
            name: "ResourceTests",
            dependencies: ["Resource"]),
        
        // MARK: - XCResourcePlugin
        
        .plugin(
            name: "XCResourcePlugin",
            capability: .buildTool(),
            dependencies: ["xcresource"]),
        
        // MARK: - StringsToSwiftPlugin
        
        .plugin(
            name: "StringsToSwiftPlugin",
            capability: .command(
                intent: .custom(verb: "strings2swift", description: "Convert strings to swift"),
                permissions: [
                    .writeToPackageDirectory(reason: "Converts strings to swift")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - StringsdictToSwiftPlugin
        
        .plugin(
            name: "StringsdictToSwiftPlugin",
            capability: .command(
                intent: .custom(verb: "stringsdict2swift",
                                description: "Convert stringsdict to swift"),
                permissions: [
                    .writeToPackageDirectory(reason: "Converts stringsdict to swift")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - StringsToCSVPlugin
        
        .plugin(
            name: "StringsToCSVPlugin",
            capability: .command(
                intent: .custom(verb: "strings2csv", description: "Convert strings to csv"),
                permissions: [
                    .writeToPackageDirectory(reason: "Converts strings to csv")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - CSVToStringsPlugin
        
        .plugin(
            name: "CSVToStringsPlugin",
            capability: .command(
                intent: .custom(verb: "csv2strings", description: "Convert csv to strings"),
                permissions: [
                    .writeToPackageDirectory(reason: "Converts csv to strings")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - xcresource
        
        .binaryTarget(
            name: "xcresource",
            url: "https://github.com/nearfri/XCResource/releases/download/0.9.25/xcresource.artifactbundle.zip",
            checksum: "b4a297dea6b6c8df93dc7149d7d548e38ec699cdcfd2477b33c013da52fd7249"
        ),
    ]
)
