import Foundation
import PackagePlugin

protocol PackagePluginContext {
    func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
}

extension PluginContext: PackagePluginContext {}

@main
struct StringsdictToSwiftPlugin: CommandPlugin {
    /// This entry point is called when operating on a Swift package.
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let scriptsDir = context.package.directory.appending(subpath: "Scripts")
        
        try perform(context: context, directoryPath: scriptsDir)
    }
    
    private func perform(context: PackagePluginContext, directoryPath: Path) throws {
        let xcresource = try context.tool(named: "xcresource")
        
        let process = Process()
        process.currentDirectoryURL = URL(fileURLWithPath: directoryPath.string)
        process.executableURL = URL(fileURLWithPath: xcresource.path.string)
        
        let arguments = """
        stringsdict2swift \
        --resources-path ../Sources/Resource/Resources \
        --language en \
        --swift-path ../Sources/Resource/Keys/StringKey.swift
        """
        process.arguments = arguments.split(separator: " ").map(String.init)
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationReason == .exit && process.terminationStatus == 0 else {
            Diagnostics.error("StringsToSwift failed.")
            return
        }
    }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension XcodePluginContext: PackagePluginContext {}

extension StringsdictToSwiftPlugin: XcodeCommandPlugin {
    /// This entry point is called when operating on an Xcode project.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        let projectDir = context.xcodeProject.directory
        let scriptsDir = projectDir.appending(subpath: "XCResourceSampleLib/Scripts")
        
        try perform(context: context, directoryPath: scriptsDir)
    }
}

#endif
