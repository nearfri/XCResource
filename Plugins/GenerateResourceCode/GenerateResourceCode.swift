import Foundation
import PackagePlugin

private enum OptionName {
    static let configurationPath: String = "configuration-path"
    static let version: String = "version"
    static let help: String = "help"
}

@main
struct GenerateResourceCode: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let toolURL = try context.tool(named: "xcresource").url
        
        let toolArguments = toolArguments(context: context, pluginArguments: arguments)
        
        try await Process.run(toolURL, arguments: toolArguments)
    }
    
    private func toolArguments(
        context: PackagePluginContext,
        pluginArguments: [String]
    ) -> [String] {
        var result: [String] = []
        
        var argExtractor = ArgumentExtractor(pluginArguments)
        
        func appendConfigPath(_ configPath: String) {
            result.append(contentsOf: ["--\(OptionName.configurationPath)", configPath])
        }
        
        if let configPath = argExtractor.extractOption(named: OptionName.configurationPath).first {
            appendConfigPath(configPath)
        } else if let configPath = configurationPath(inDirectory: context.currentDirectoryURL) {
            appendConfigPath(configPath)
        }
        
        for flag in [OptionName.version, OptionName.help] {
            if argExtractor.extractFlag(named: flag) > 0 {
                result.append("--\(flag)")
            }
        }
        
        return result
    }
    
    private func configurationPath(inDirectory directory: URL) -> String? {
        let filename = "xcresource.json"
        
        let candidates: [String] = [
            "Configs/\(filename)", "Configs/\(filename)5",
            "Scripts/\(filename)", "Scripts/\(filename)5",
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

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension GenerateResourceCode: XcodeCommandPlugin {
    // Entry point for command plugins applied to Xcode projects.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        let toolURL = try context.tool(named: "xcresource").url
        
        let toolArguments = toolArguments(context: context, pluginArguments: arguments)
        
        try Process.run(toolURL, arguments: toolArguments)
    }
}

#endif
