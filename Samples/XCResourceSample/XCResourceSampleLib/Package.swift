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
            name: "StringsToSwift",
            targets: ["StringsToSwift"]),
        .plugin(
            name: "StringsToCSV",
            targets: ["StringsToCSV"]),
        .plugin(
            name: "CSVToStrings",
            targets: ["CSVToStrings"]),
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
            plugins: [.plugin(name: "GenerateResourceKeys")]),
        
        .testTarget(
            name: "ResourceTests",
            dependencies: ["Resource"]),
        
        // MARK: - GenerateResourceKeys
        
        .plugin(
            name: "GenerateResourceKeys",
            capability: .buildTool(),
            dependencies: ["xcresource"]),
        
        // MARK: - StringsToSwift
        
        .plugin(
            name: "StringsToSwift",
            capability: .command(
                intent: .custom(verb: "strings2swift", description: "Convert strings to swift"),
                permissions: [
                    .writeToPackageDirectory(reason: "Converts strings to swift")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - StringsToCSV
        
        .plugin(
            name: "StringsToCSV",
            capability: .command(
                intent: .custom(verb: "strings2csv", description: "Convert strings to csv"),
                permissions: [
                    .writeToPackageDirectory(reason: "Converts strings to csv")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - CSVToStrings
        
        .plugin(
            name: "CSVToStrings",
            capability: .command(
                intent: .custom(verb: "csv2strings", description: "Convert csv to strings"),
                permissions: [
                    .writeToPackageDirectory(reason: "Converts csv to strings")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - xcresource
        
        .binaryTarget(
            name: "xcresource",
            url: "https://github.com/nearfri/XCResource/releases/download/0.9.20/xcresource.artifactbundle.zip",
            checksum: "5c4f9630f85406d641bf0dc5a8ce4ff569a0140ab0a99e0b18cd5a776531ddf7"
        ),
    ]
)
