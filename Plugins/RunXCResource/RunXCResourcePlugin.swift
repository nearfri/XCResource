import Foundation
import PackagePlugin

private enum OptionName {
    static let manifestPath: String = "manifest-path"
    static let version: String = "version"
    static let help: String = "help"
}

@main
struct RunXCResourcePlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let tool = try context.tool(named: "xcresource")
        
        let toolArguments = toolArguments(context: context, pluginArguments: arguments)
        
        try await tool.execute(arguments: toolArguments)
    }
    
    private func toolArguments(context: PluginContext, pluginArguments: [String]) -> [String] {
        var result: [String] = []
        
        var argExtractor = ArgumentExtractor(pluginArguments)
        
        func appendManifestPath(_ manifestPath: String) {
            result.append(contentsOf: ["--\(OptionName.manifestPath)", manifestPath])
        }
        
        if let manifestPath = argExtractor.extractOption(named: OptionName.manifestPath).first {
            appendManifestPath(manifestPath)
        } else if let manifestPath = manifestPath(inDirectory: context.package.directoryURL) {
            appendManifestPath(manifestPath)
        }
        
        for flag in [OptionName.version, OptionName.help] {
            if argExtractor.extractFlag(named: flag) > 0 {
                result.append("--\(flag)")
            }
        }
        
        return result
    }
    
    private func manifestPath(inDirectory directory: URL) -> String? {
        let filename = "xcresource.json"
        
        let candidates: [String] = [
            "Configs/\(filename)",
            "Scripts/\(filename)",
        ]
        
        for candidate in candidates {
            let path = directory.appending(path: candidate).path(percentEncoded: false)
            
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        
        return nil
    }
}
