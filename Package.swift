// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

private func swiftSyntaxVersion() -> Package.Dependency.Requirement {
#if swift(>=5.6)
    return .exact("0.50600.0")
#elseif swift(>=5.5)
    return .exact("0.50500.0")
#else
    return .exact("0.50400.0")
#endif
}

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
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.2"),
        .package(url: "https://github.com/nearfri/Strix", from: "2.3.6"),
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax", swiftSyntaxVersion()),
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
            path: "Tests/_SampleData",
            resources: [
                // 테스트용 리소스 폴더로 쓰기 위해 통째로 복사한다.
                .copy("Resources"),
            ]),
    ]
)

fixRPathProblem()

private func fixRPathProblem() {
    let bundleID = ProcessInfo.processInfo.environment["__CFBundleIdentifier"]
    if bundleID == "com.apple.dt.Xcode" {
        addToolchainPathToRPath()
    }
}

private func addToolchainPathToRPath() {
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

private func toolchainPath() throws -> String {
    let developerPath = try Bash.execute(command: "xcode-select", arguments: ["-p"]).trimmed
    return "\(developerPath)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx"
}

private extension String {
    var trimmed: String { trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
}

private enum Bash {
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
