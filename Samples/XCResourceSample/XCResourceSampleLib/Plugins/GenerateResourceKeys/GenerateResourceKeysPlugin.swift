import Foundation
import PackagePlugin

@main
struct GenerateResourceKeysPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let xcresource = try context.tool(named: "xcresource").path
        
        return [
            .prebuildCommand(
                displayName: "Run xcresource",
                executable: Path("/usr/bin/make"),
                arguments: [
                    "-C", "\(context.package.directory)/Scripts",
                    "XCRESOURCE=\(xcresource)",
                ],
                environment: ["PATH": "/usr/bin"],
                outputFilesDirectory: context.pluginWorkDirectory),
        ]
    }
}
