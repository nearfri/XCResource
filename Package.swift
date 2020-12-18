// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ResourceKey",
    defaultLocalization: "en",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        .executable(name: "generate-asset-keys", targets: ["generate-asset-keys"]),
        .executable(name: "generate-localizable-strings", targets: ["generate-localizable-strings"]),
        .library(name: "AssetKeyGen", targets: ["AssetKeyGen"]),
        .library(name: "LocStringGen", targets: ["LocStringGen"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax", .exact("0.50300.0")),
        .package(url: "https://github.com/nearfri/Strix", from: "2.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        // MARK: - generate-asset-keys
        
        .target(
            name: "generate-asset-keys",
            dependencies: [
                "AssetKeyGen",
                "ResourceKeyUtil",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "generate-asset-keysTests",
            dependencies: ["generate-asset-keys", "SampleData"]),
        
        // MARK: - generate-localizable-strings
        
        .target(
            name: "generate-localizable-strings",
            dependencies: [
                "LocStringGen",
                "ResourceKeyUtil",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "generate-localizable-stringsTests",
            dependencies: ["generate-localizable-strings", "SampleData"]),
        
        // MARK: - AssetKeyGen
        
        .target(
            name: "AssetKeyGen",
            dependencies: ["ResourceKeyUtil"]),
        .testTarget(
            name: "AssetKeyGenTests",
            dependencies: ["AssetKeyGen", "SampleData"]),
        
        // MARK: - LocStringGen
        
        .target(
            name: "LocStringGen",
            dependencies: [
                "ResourceKeyUtil",
                "SwiftSyntax",
                .product(name: "StrixParsers", package: "Strix"),
            ]),
        .testTarget(
            name: "LocStringGenTests",
            dependencies: ["LocStringGen", "SwiftSyntax", "SampleData"]),
        
        // MARK: - ResourceKeyUtil
        
        .target(
            name: "ResourceKeyUtil",
            dependencies: []),
        .testTarget(
            name: "ResourceKeyUtilTests",
            dependencies: ["ResourceKeyUtil"]),
        
        // MARK: - SampleData
        
        .target(
            name: "SampleData",
            resources: [
                // 테스트용 리소스 폴더로 쓰기 위해 통째로 복사한다.
                .copy("Resources"),
            ]),
    ]
)
