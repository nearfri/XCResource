// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCResourceExampleLib",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macCatalyst(.v17), .macOS(.v14)],
    products: [
        .library(name: "XCResourceExampleLib", targets: ["View", "Resources"]),
    ],
    dependencies: [
        .package(path: "../../../"),
//        .package(url: "https://github.com/nearfri/XCResource-plugin.git", from: "1.1.6"),
    ],
    targets: [
        // MARK: - Core Modules
        
        .target(
            name: "View",
            dependencies: ["Resources"]),
        
        .target(
            name: "Resources",
            dependencies: [],
            resources: [
                .copy("Resources/Fonts"),
            ],
            plugins: []),
        
        // MARK: - Tests
        
        .testTarget(
            name: "ResourcesTests",
            dependencies: ["Resources"]),
    ]
)
