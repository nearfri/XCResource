import Foundation
import PackagePlugin

protocol PackagePluginContext {
    func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
}

extension PluginContext: PackagePluginContext {}

@main
struct CSVToStringsPlugin: CommandPlugin {
    /// This entry point is called when operating on a Swift package.
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let scriptsDir = context.package.directory.appending(subpath: "Scripts")
        
        try performStringsToCSV(context: context, directoryPath: scriptsDir)
    }
    
    private func performStringsToCSV(context: PackagePluginContext, directoryPath: Path) throws {
        let xcresource = try context.tool(named: "xcresource")
        
        let process = Process()
        process.currentDirectoryURL = URL(fileURLWithPath: directoryPath.string)
        process.executableURL = URL(fileURLWithPath: xcresource.path.string)
        process.arguments = [
            "csv2strings",
            "--csv-path", "./XCResourceSample-localizations.csv",
            "--header-style", "long-en",
            "--resources-path", "../Sources/Resource/Resources",
            "--empty-encoding", "#EMPTY",
        ]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationReason == .exit && process.terminationStatus == 0 else {
            Diagnostics.error("StringsToCSV failed.")
            return
        }
    }
    
    // try performShellCommand("make strings2csv", at: scriptsDir)
    private func performShellCommand(_ command: String, at directoryPath: Path) throws {
        let process = Process()
        process.currentDirectoryURL = URL(fileURLWithPath: directoryPath.string)
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command]
        process.environment = ["PATH": "/usr/bin:~/.mint/bin"]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationReason == .exit && process.terminationStatus == 0 else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("'\(command)' failed: \(problem)")
            return
        }
    }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension XcodePluginContext: PackagePluginContext {}

extension CSVToStringsPlugin: XcodeCommandPlugin {
    /// This entry point is called when operating on an Xcode project.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        let projectDir = context.xcodeProject.directory
        let scriptsDir = projectDir.appending(subpath: "XCResourceSampleLib/Scripts")
        
        try performStringsToCSV(context: context, directoryPath: scriptsDir)
    }
}

#endif
