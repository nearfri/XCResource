// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "XCResource",
    platforms: [.macOS(.v13)],
    products: [
        .plugin(name: "RunXCResource", targets: ["RunXCResource"]),
        .executable(name: "xcresource-bin", targets: ["xcresource"]),
        .executable(name: "xcresource", targets: ["XCResourceCLI"]),
        .library(name: "XCResourceCommand", targets: ["XCResourceCommand"]),
        .library(name: "AssetKeyGen", targets: ["AssetKeyGen"]),
        .library(name: "FontKeyGen", targets: ["FontKeyGen"]),
        .library(name: "LocStringKeyGen", targets: ["LocStringKeyGen"]),
        .library(name: "LocStringsGen", targets: ["LocStringsGen"]),
        .library(name: "LocStringFormGen", targets: ["LocStringFormGen"]),
        .library(name: "LocCSVGen", targets: ["LocCSVGen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.3"),
        .package(url: "https://github.com/nearfri/Strix", from: "2.3.7"),
    ],
    targets: [
        // MARK: - Released Binary
        
        .binaryTarget(
            name: "xcresource",
            url: "https://github.com/nearfri/XCResource/releases/download/0.9.27/xcresource.artifactbundle.zip",
            checksum: "0a82e7371d4f002ae958ccac7d643b386da3def113cdbe905b62d1cd51ee95f1"
        ),
        
        // MARK: - Plugins
        
        .plugin(
            name: "RunXCResource",
            capability: .command(
                intent: .custom(
                    verb: "run-xcresource",
                    description: "Run XCResource to generate symbols for assets or strings."),
                permissions: [
                    .writeToPackageDirectory(
                        reason: "Write symbol files in the package direcotry")
                ]),
            dependencies: ["xcresource"]),
        
        // MARK: - Executables
        
        .executableTarget(
            name: "XCResourceCLI",
            dependencies: ["XCResourceCommand"]),
        
        // MARK: - Command Module
        
        .target(
            name: "XCResourceCommand",
            dependencies: [
                "AssetKeyGen",
                "FontKeyGen",
                "LocStringKeyGen",
                "LocStringsGen",
                "LocStringFormGen",
                "LocCSVGen",
                "XCResourceUtil",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        
        // MARK: - Core Modules
        
        .target(
            name: "AssetKeyGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "FontKeyGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "LocStringKeyGen",
            dependencies: [
                "LocStringCore",
                "LocSwiftCore",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "OrderedCollections", package: "swift-collections"),
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
                "LocStringCore",
                "LocSwiftCore",
                .product(name: "StrixParsers", package: "Strix"),
            ]),
        .target(
            name: "LocCSVGen",
            dependencies: [
                "LocStringCore",
                "XCResourceUtil",
                .product(name: "StrixParsers", package: "Strix"),
            ]),
        .target(
            name: "LocStringCore",
            dependencies: [
                "XCResourceUtil",
                .product(name: "StrixParsers", package: "Strix"),
                .product(name: "OrderedCollections", package: "swift-collections"),
            ]),
        .target(
            name: "LocSwiftCore",
            dependencies: [
                "LocStringCore",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]),
        .target(
            name: "XCResourceUtil",
            dependencies: []),
        
        // MARK: - Tests
        
        .testTarget(
            name: "XCResourceCLITests",
            dependencies: ["XCResourceCLI", "SampleData"]),
        .testTarget(
            name: "XCResourceCommandTests",
            dependencies: ["XCResourceCommand", "SampleData", "TestUtil"]),
        .testTarget(
            name: "AssetKeyGenTests",
            dependencies: ["AssetKeyGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "FontKeyGenTests",
            dependencies: ["FontKeyGen", "SampleData", "TestUtil"]),
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
