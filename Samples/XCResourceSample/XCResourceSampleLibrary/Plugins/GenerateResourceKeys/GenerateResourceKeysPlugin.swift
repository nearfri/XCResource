import Foundation
import PackagePlugin

@main
struct GenerateResourceKeysPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        // swiftgen으로 해야 xcresource가 호출되네? 🤔
        let xcresource = try context.tool(named: "swiftgen").path
        
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
