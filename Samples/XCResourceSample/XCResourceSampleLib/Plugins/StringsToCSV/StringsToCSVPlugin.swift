import Foundation
import PackagePlugin

protocol PackagePluginContext {
    func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
}

extension PluginContext: PackagePluginContext {}

@main
struct StringsToCSVPlugin: CommandPlugin {
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
        
        let arguments = """
        strings2csv \
        --resources-path ../Sources/Resource/Resources \
        --development-language en \
        --csv-path ./XCResourceSample-localizations.csv \
        --header-style long-en \
        --empty-encoding #EMPTY \
        --write-bom
        """
        process.arguments = arguments.split(separator: " ").map(String.init)
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationReason == .exit && process.terminationStatus == 0 else {
            Diagnostics.error("StringsToCSV failed.")
            return
        }
    }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension XcodePluginContext: PackagePluginContext {}

extension StringsToCSVPlugin: XcodeCommandPlugin {
    /// This entry point is called when operating on an Xcode project.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        let projectDir = context.xcodeProject.directory
        let scriptsDir = projectDir.appending(subpath: "XCResourceSampleLib/Scripts")
        
        try performStringsToCSV(context: context, directoryPath: scriptsDir)
    }
}

#endif
