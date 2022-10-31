// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

#if swift(>=5.6)
private let swiftSyntax = SwiftSyntaxPackage(
    version: "0.50700.1",
    internalParser: .init(
        version: "5.7.1",
        checksum: "feb332ba0a027812b1ee7f552321d6069a46207e5cd0f64fa9bb78e2a261b366"))
#endif

let package = Package(
    name: "XCResource",
    defaultLocalization: "en",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "xcresource", targets: ["XCResourceCLI"]),
        .library(name: "XCResourceCommand", targets: ["XCResourceCommand"]),
        .library(name: "AssetKeyGen", targets: ["AssetKeyGen"]),
        .library(name: "LocStringGen", targets: ["LocStringGen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),
        .package(url: "https://github.com/nearfri/Strix", from: "2.3.7"),
        swiftSyntax.packageDependency,
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
                "LocStringGen",
                "XCResourceUtil",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "XCResourceCommandTests",
            dependencies: ["XCResourceCommand", "SampleData"]),
        
        // MARK: - AssetKeyGen
        
        .target(
            name: "AssetKeyGen",
            dependencies: ["XCResourceUtil"]),
        .testTarget(
            name: "AssetKeyGenTests",
            dependencies: ["AssetKeyGen", "SampleData"]),
        
        // MARK: - LocStringGen
        
        .target(
            name: "LocStringGen",
            dependencies: [
                "XCResourceUtil",
                .product(name: "StrixParsers", package: "Strix"),
            ] + swiftSyntax.targetDependencies,
            linkerSettings: swiftSyntax.linkerSettings),
        .testTarget(
            name: "LocStringGenTests",
            dependencies: ["LocStringGen", "SampleData"] + swiftSyntax.targetDependencies),
        
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
        
        // MARK: - lib_InternalSwiftSyntaxParser
        
        swiftSyntax.internalParserTarget,
    ]
)

private struct SwiftSyntaxPackage {
    struct InternalParser {
        var version: String
        var checksum: String
    }
    
    var version: Version
    var internalParser: InternalParser
    
    var packageDependency: Package.Dependency {
        return .package(url: "https://github.com/apple/swift-syntax", exact: version)
    }
    
    var targetDependencies: [Target.Dependency] {
        return [
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
            "lib_InternalSwiftSyntaxParser",
        ]
    }
    
    // Pass `-dead_strip_dylibs` to ignore the dynamic version of `lib_InternalSwiftSyntaxParser`
    // that ships with SwiftSyntax because we want the static version from
    // `StaticInternalSwiftSyntaxParser`.
    var linkerSettings: [LinkerSetting] {
        return [.unsafeFlags(["-Xlinker", "-dead_strip_dylibs"])]
    }
    
    var internalParserTarget: Target {
        return .binaryTarget(
            name: "lib_InternalSwiftSyntaxParser",
            url: "https://github.com/keith/StaticInternalSwiftSyntaxParser/releases/download/"
            + "\(internalParser.version)/lib_InternalSwiftSyntaxParser.xcframework.zip",
            checksum: internalParser.checksum)
    }
}
