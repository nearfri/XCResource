// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "XCResource",
    platforms: [.macOS(.v14)],
    products: [
        .plugin(name: "RunXCResource", targets: ["RunXCResource"]),
        .executable(name: "xcresource-bin", targets: ["xcresource"]),
        .executable(name: "xcresource", targets: ["XCResourceCLI"]),
        .library(name: "XCResourceCommand", targets: ["XCResourceCommand"]),
        .library(name: "AssetKeyGen", targets: ["AssetKeyGen"]),
        .library(name: "FileKeyGen", targets: ["FileKeyGen"]),
        .library(name: "FontKeyGen", targets: ["FontKeyGen"]),
        .library(name: "LocStringResourceGen", targets: ["LocStringResourceGen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),
        .package(url: "https://github.com/apple/swift-syntax", from: "510.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.3"),
        .package(url: "https://github.com/nearfri/Strix", from: "2.3.7"),
    ],
    targets: [
        // MARK: - Released Binary
        
        .binaryTarget(
            name: "xcresource",
            url: "https://github.com/nearfri/XCResource/releases/download/0.11.1/xcresource.artifactbundle.zip",
            checksum: "d7f0961a977878b2d61476ede66be9789104a12b1e90f4a255eace93ac0dbd69"
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
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "AssetKeyGen",
                "FileKeyGen",
                "FontKeyGen",
                "LocStringResourceGen",
                "LocStringKeyGen",
                "LocStringsGen",
                "LocStringFormGen",
                "LocCSVGen",
                "XCResourceUtil",
            ]),
        
        // MARK: - Core Modules
        
        .target(
            name: "AssetKeyGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "FileKeyGen",
            dependencies: ["XCResourceUtil"]),
        .target(
            name: "FontKeyGen",
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
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
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
            dependencies: ["XCResourceCLI", "SampleData"]),
        .testTarget(
            name: "XCResourceCommandTests",
            dependencies: ["XCResourceCommand", "SampleData", "TestUtil"]),
        .testTarget(
            name: "AssetKeyGenTests",
            dependencies: ["AssetKeyGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "FileKeyGenTests",
            dependencies: ["FileKeyGen", "SampleData", "TestUtil"]),
        .testTarget(
            name: "FontKeyGenTests",
            dependencies: ["FontKeyGen", "SampleData", "TestUtil"]),
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
