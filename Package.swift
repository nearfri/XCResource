// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "XCResource",
    platforms: [.macOS(.v15)],
    products: [
        .plugin(name: "Generate Resource Code", targets: ["Generate Resource Code"]),
        .executable(name: "xcresource", targets: ["xcresource"]),
        .library(name: "XCResourceCommand", targets: ["XCResourceCommand"]),
        .library(name: "AssetResourceGen", targets: ["AssetResourceGen"]),
        .library(name: "FileResourceGen", targets: ["FileResourceGen"]),
        .library(name: "FontResourceGen", targets: ["FontResourceGen"]),
        .library(name: "LocStringResourceGen", targets: ["LocStringResourceGen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.4"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.1"),
//        .package(url: "https://github.com/swiftlang/swift--docc-plugin.git", from: "1.4.3"),
        .package(url: "https://github.com/nearfri/Strix.git", from: "2.4.6"),
    ],
    targets: [
        // MARK: - Documentation
        // Empty target that builds the DocC catalog at Documentation/XCResourcePlugin.docc
        .target(name: "Documentation", path: "Documentation"),
        
        // MARK: - Plugins
        .plugin(
            name: "Generate Resource Code",
            capability: .command(
                intent: .custom(
                    verb: "generate-resource-code",
                    description: "Generate source code for resources"),
                permissions: [
                    .writeToPackageDirectory(
                        reason: "Generate Swift source files for accessing resources")
                ]),
            dependencies: ["xcresource"],
            path: "Plugins/GenerateResourceCode"),
        
        // MARK: - Executables
        
        .executableTarget(
            name: "xcresource",
            dependencies: ["XCResourceCommand"],
            path: "Sources/XCResourceCLI"),
        
        // MARK: - Command Module
        
        .target(
            name: "XCResourceCommand",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "AssetResourceGen",
                "FileResourceGen",
                "FontResourceGen",
                "LocStringResourceGen",
                "XCResourceUtil",
            ]),
        
        // MARK: - Core Modules
        
        .target(
            name: "AssetResourceGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "FileResourceGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "FontResourceGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "LocStringResourceGen",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftRefactor", package: "swift-syntax"),
                .product(name: "StrixParsers", package: "Strix"),
                "XCResourceUtil",
            ]),
        .target(
            name: "XCResourceUtil",
            dependencies: []),
        
        // MARK: - Tests
        
        .testTarget(
            name: "XCResourceCLITests",
            dependencies: ["xcresource", "SampleData"]),
        .testTarget(
            name: "XCResourceCommandTests",
            dependencies: ["XCResourceCommand", "SampleData", "TestUtil"]),
        .testTarget(
            name: "AssetResourceGenTests",
            dependencies: ["AssetResourceGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "FileResourceGenTests",
            dependencies: ["FileResourceGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "FontResourceGenTests",
            dependencies: ["FontResourceGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "LocStringResourceGenTests",
            dependencies: ["LocStringResourceGen", "TestUtil"]),
        .testTarget(
            name: "XCResourceUtilTests",
            dependencies: ["XCResourceUtil"]),
        
        // MARK: - Test Tools
        
        .target(
            name: "SampleData",
            path: "Tests/_SampleData",
            resources: [
                .copy("Resources"),
            ]),
        .target(
            name: "TestUtil",
            path: "Tests/_TestUtil"),
    ]
)
