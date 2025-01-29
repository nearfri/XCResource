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
        .library(name: "FileKeyGen", targets: ["FileKeyGen"]),
        .library(name: "FontResourceGen", targets: ["FontResourceGen"]),
        .library(name: "LocStringResourceGen", targets: ["LocStringResourceGen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.4"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.3"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
//        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
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
                    description: "Generate source code for resources."),
                permissions: [
                    .writeToPackageDirectory(
                        reason: "Generate and write source code into the package direcotry")
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
                "FileKeyGen",
                "FontResourceGen",
                "LocStringResourceGen",
                "LocStringKeyGen",
                "LocStringsGen",
                "LocStringFormGen",
                "LocCSVGen",
                "XCResourceUtil",
            ]),
        
        // MARK: - Core Modules
        
        .target(
            name: "AssetResourceGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "FileKeyGen",
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
            name: "LocStringKeyGen",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "OrderedCollections", package: "swift-collections"),
                "LocStringCore",
                "LocSwiftCore",
            ]),
        .target(
            name: "LocStringsGen",
            dependencies: [
                "LocStringCore",
                "LocSwiftCore",
                "XCResourceUtil",
            ]),
        .target(
            name: "LocStringFormGen",
            dependencies: [
                .product(name: "StrixParsers", package: "Strix"),
                "LocStringCore",
                "LocSwiftCore",
            ]),
        .target(
            name: "LocCSVGen",
            dependencies: [
                .product(name: "StrixParsers", package: "Strix"),
                "LocStringCore",
                "XCResourceUtil",
            ]),
        .target(
            name: "LocStringCore",
            dependencies: [
                .product(name: "StrixParsers", package: "Strix"),
                .product(name: "OrderedCollections", package: "swift-collections"),
                "XCResourceUtil",
            ]),
        .target(
            name: "LocSwiftCore",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                "LocStringCore",
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
            name: "FileKeyGenTests",
            dependencies: ["FileKeyGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "FontResourceGenTests",
            dependencies: ["FontResourceGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "LocStringResourceGenTests",
            dependencies: ["LocStringResourceGen", "TestUtil"]),
        .testTarget(
            name: "LocStringKeyGenTests",
            dependencies: ["LocStringKeyGen", "TestUtil"]),
        .testTarget(
            name: "LocStringsGenTests",
            dependencies: ["LocStringsGen", "TestUtil"]),
        .testTarget(
            name: "LocStringFormGenTests",
            dependencies: ["LocStringFormGen", "TestUtil"]),
        .testTarget(
            name: "LocCSVGenTests",
            dependencies: ["LocCSVGen", "TestUtil"]),
        .testTarget(
            name: "LocStringCoreTests",
            dependencies: ["LocStringCore", "SampleData", "TestUtil"]),
        .testTarget(
            name: "LocSwiftCoreTests",
            dependencies: ["LocSwiftCore"]),
        .testTarget(
            name: "XCResourceUtilTests",
            dependencies: ["XCResourceUtil"]),
        
        // MARK: - Test Tools
        
        .target(
            name: "SampleData",
            path: "Tests/_SampleData",
            resources: [
                // 테스트용 리소스 폴더로 쓰기 위해 통째로 복사한다.
                .copy("Resources"),
            ]),
        .target(
            name: "TestUtil",
            path: "Tests/_TestUtil"),
    ]
)
