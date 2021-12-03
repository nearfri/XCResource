// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.5.0"),
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax", .exact("0.50500.0")),
        .package(url: "https://github.com/nearfri/Strix", from: "2.3.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
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
                "SwiftSyntax",
                .product(name: "StrixParsers", package: "Strix"),
            ]),
        .testTarget(
            name: "LocStringGenTests",
            dependencies: ["LocStringGen", "SwiftSyntax", "SampleData"]),
        
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
            resources: [
                // 테스트용 리소스 폴더로 쓰기 위해 통째로 복사한다.
                .copy("Resources"),
            ]),
    ]
)

fixRPathProblem()

func fixRPathProblem() {
    let bundleID = ProcessInfo.processInfo.environment["__CFBundleIdentifier"]
    if bundleID == "com.apple.dt.Xcode" {
        addToolchainPathToRPath()
    }
}

func addToolchainPathToRPath() {
    do {
        let linkerSetting = LinkerSetting.unsafeFlags(["-rpath", try toolchainPath()])
        
        package
            .targets
            .filter(\.isTest)
            .forEach({ $0.linkerSettings = [linkerSetting] })
    } catch {
        preconditionFailure("\(error.localizedDescription)")
    }
}

func toolchainPath() throws -> String {
    let developerPath = try Bash.execute(command: "xcode-select", arguments: ["-p"]).trimmed
    return "\(developerPath)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx"
}

extension String {
    var trimmed: String { trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
}

enum Bash {
    @discardableResult
    static func execute(command: String, arguments: [String] = []) throws -> String {
        let path = try execute(path: "/bin/bash", arguments: ["-lc", "which \(command)"]).trimmed
        return try execute(path: path, arguments: arguments)
    }
    
    @discardableResult
    static func execute(path: String, arguments: [String] = []) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        
        try process.run()
        process.waitUntilExit()
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
}
