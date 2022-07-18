// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCResourceSampleLibrary",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macCatalyst(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "XCResourceSampleLibrary",
            targets: ["View", "Resource"]),
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
            url: "https://github.com/nearfri/XCResource/releases/download/0.9.17/xcresource.artifactbundle.zip",
            checksum: "8ee54550ad2ae460c3178b0e66bdf3dcca85f1b6417613109f70af232f00c0c9"
        ),
    ]
)
