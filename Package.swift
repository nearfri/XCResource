// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ResourceKey",
    defaultLocalization: "en",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "generate-asset-keys", targets: ["generate-asset-keys"]),
        .library(name: "AssetKeyGen", targets: ["AssetKeyGen"]),
        .library(name: "StaticKeyListGen", targets: ["StaticKeyListGen"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
        .package(url: "https://github.com/jpsim/SourceKitten", from: "0.30.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "generate-asset-keys",
            dependencies: [
                "AssetKeyGen",
                "Util",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "generate-asset-keysTests",
            dependencies: ["generate-asset-keys"]),
        
        .target(
            name: "AssetKeyGen",
            dependencies: ["Util"]),
        .testTarget(
            name: "AssetKeyGenTests",
            dependencies: ["AssetKeyGen", "SampleData"]),
        
        .target(
            name: "StaticKeyListGen",
            dependencies: [
                .product(name: "SourceKittenFramework", package: "SourceKitten"),
            ]),
        .testTarget(
            name: "StaticKeyListGenTests",
            dependencies: ["StaticKeyListGen"]),
        
        .target(
            name: "Util",
            dependencies: []),
        .testTarget(
            name: "UtilTests",
            dependencies: ["Util"]),
        
        .target(
            name: "SampleData",
            resources: [
                // 테스트용 애셋 폴더로 쓰기 위해 통째로 복사한다.
                .copy("Resources"),
            ]),
    ]
)
