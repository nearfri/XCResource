// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCResourceSampleLib",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macCatalyst(.v15), .macOS(.v12)],
    products: [
        .library(name: "XCResourceSampleLib", targets: ["View", "Resource"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../../../"),
    ],
    targets: [
        // MARK: - Core Modules
        
        .target(
            name: "View",
            dependencies: ["Resource"]),
        
        .target(
            name: "Resource",
            dependencies: [],
            resources: [.copy("Resources/Fonts")],
            plugins: []),
        
        // MARK: - Tests
        
        .testTarget(
            name: "ResourceTests",
            dependencies: ["Resource"]),
    ]
)
