// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "XCResource",
    defaultLocalization: "en",
    platforms: [.macOS(.v13)],
    products: [
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
            url: "https://github.com/nearfri/XCResource/releases/download/0.9.26/xcresource.artifactbundle.zip",
            checksum: "282d450a5c22d7f61b11f955aeacf651db60ddf574746eb4960409e5df9c0e5f"
        ),
        
        // MARK: - Executables
        
        .executableTarget(
            name: "XCResourceCLI",
            dependencies: ["XCResourceCommand"]),
        
        // MARK: - Command Library
        
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
        
        // MARK: - Core Libraries
        
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
