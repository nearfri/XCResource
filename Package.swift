// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "XCResource",
    defaultLocalization: "en",
    platforms: [.macOS(.v12)],
    products: [
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
        .package(url: "https://github.com/apple/swift-syntax", from: "508.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.3"),
        .package(url: "https://github.com/nearfri/Strix", from: "2.3.7"),
    ],
    targets: [
        // MARK: - XCResourceCLI
        
        .executableTarget(
            name: "XCResourceCLI",
            dependencies: ["XCResourceCommand"]),
        .testTarget(
            name: "XCResourceCLITests",
            dependencies: ["XCResourceCLI", "SampleData"]),
        
        // MARK: - XCResourceCommand
        
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
        .testTarget(
            name: "XCResourceCommandTests",
            dependencies: ["XCResourceCommand", "SampleData", "TestUtil"]),
        
        // MARK: - AssetKeyGen
        
        .target(
            name: "AssetKeyGen",
            dependencies: ["XCResourceUtil"]),
        .testTarget(
            name: "AssetKeyGenTests",
            dependencies: ["AssetKeyGen", "SampleData", "TestUtil"]),
        
        // MARK: - FontKeyGen
        
        .target(
            name: "FontKeyGen",
            dependencies: ["XCResourceUtil"]),
        .testTarget(
            name: "FontKeyGenTests",
            dependencies: ["FontKeyGen", "SampleData", "TestUtil"]),
        
        // MARK: - LocStringKeyGen
        
        .target(
            name: "LocStringKeyGen",
            dependencies: [
                "LocStringCore",
                "LocSwiftCore",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "OrderedCollections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "LocStringKeyGenTests",
            dependencies: [
                "LocStringKeyGen",
                "TestUtil",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]),
        
        // MARK: - LocStringsGen
        
        .target(
            name: "LocStringsGen",
            dependencies: [
                "LocStringCore",
                "LocSwiftCore",
                "XCResourceUtil",
            ]),
        .testTarget(
            name: "LocStringsGenTests",
            dependencies: [
                "LocStringsGen",
                "TestUtil",
            ]),
        
        // MARK: - LocStringFormGen
        
        .target(
            name: "LocStringFormGen",
            dependencies: [
                "LocStringCore",
                "LocSwiftCore",
                .product(name: "StrixParsers", package: "Strix"),
            ]),
        .testTarget(
            name: "LocStringFormGenTests",
            dependencies: [
                "LocStringFormGen",
                "TestUtil",
            ]),
        
        // MARK: - LocCSVGen
        
        .target(
            name: "LocCSVGen",
            dependencies: [
                "LocStringCore",
                "XCResourceUtil",
                .product(name: "StrixParsers", package: "Strix"),
            ]),
        .testTarget(
            name: "LocCSVGenTests",
            dependencies: [
                "LocCSVGen", "TestUtil"
            ]),
        
        // MARK: - LocStringCore
        
        .target(
            name: "LocStringCore",
            dependencies: [
                "XCResourceUtil",
                .product(name: "StrixParsers", package: "Strix"),
                .product(name: "OrderedCollections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "LocStringCoreTests",
            dependencies: ["LocStringCore", "SampleData", "TestUtil"]),
        
        // MARK: - LocSwiftCore
        
        .target(
            name: "LocSwiftCore",
            dependencies: [
                "LocStringCore",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]),
        .testTarget(
            name: "LocSwiftCoreTests",
            dependencies: [
                "LocSwiftCore",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]),
        
        // MARK: - XCResourceUtil
        
        .target(
            name: "XCResourceUtil",
            dependencies: []),
        .testTarget(
            name: "XCResourceUtilTests",
            dependencies: ["XCResourceUtil"]),
        
        // MARK: - SampleData
        
        .target(
            name: "SampleData",
            path: "Tests/_SampleData",
            resources: [
                // 테스트용 리소스 폴더로 쓰기 위해 통째로 복사한다.
                .copy("Resources"),
            ]),
        
        // MARK: - TestUtil
        
        .target(
            name: "TestUtil",
            path: "Tests/_TestUtil"),
    ]
)
