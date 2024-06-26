// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCResourceSampleLib",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macCatalyst(.v17), .macOS(.v14)],
    products: [
        .library(name: "XCResourceSampleLib", targets: ["View", "Resource"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../../../"),
    ],
    targets: [
        // MARK: - Plugins
        
        .plugin(
            name: "RunXCResource-Dev",
            capability: .command(
                intent: .custom(
                    verb: "run-xcresource",
                    description: "Run XCResource to generate symbols for assets or strings."),
                permissions: [
                    .writeToPackageDirectory(
                        reason: "Write symbol files in the package direcotry")
                ]),
            dependencies: [.product(name: "xcresource", package: "XCResource")]),
        
        // MARK: - Core Modules
        
        .target(
            name: "View",
            dependencies: ["Resource"]),
        
        .target(
            name: "Resource",
            dependencies: [],
            resources: [
                .process("Resources/Assets.xcassets"),
                .process("Resources/Localizable.xcstrings"),
                .copy("Resources/Fonts"),
            ],
            plugins: []),
        
        // MARK: - Tests
        
        .testTarget(
            name: "ResourceTests",
            dependencies: ["Resource"]),
    ]
)
