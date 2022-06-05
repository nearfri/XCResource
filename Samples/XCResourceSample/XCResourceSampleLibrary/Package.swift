// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCResourceSampleLibrary",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macCatalyst(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "XCResourceSampleLibrary",
            targets: ["View", "Resource"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // MARK: - View
        
        .target(
            name: "View",
            dependencies: ["Resource"]),
        
        // MARK: - Resource
        
        .target(
            name: "Resource",
            dependencies: []),
        .testTarget(
            name: "ResourceTests",
            dependencies: ["Resource"]),
    ]
)
