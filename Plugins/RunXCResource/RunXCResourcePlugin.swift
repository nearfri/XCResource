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
        
        func appendManifestPath(_ manifestPath: String) {
            result.append(contentsOf: ["--\(OptionName.manifestPath)", manifestPath])
        }
        
        if let manifestPath = argExtractor.extractOption(named: OptionName.manifestPath).first {
            appendManifestPath(manifestPath)
        } else if let manifestPath = manifestPath(inDirectory: context.currentDirectoryURL) {
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

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension RunXCResourcePlugin: XcodeCommandPlugin {
    // Entry point for command plugins applied to Xcode projects.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        let toolURL = try context.tool(named: "xcresource").url
        
        let toolArguments = toolArguments(context: context, pluginArguments: arguments)
        
        var processError: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                try await Process.run(toolURL, arguments: toolArguments)
            } catch {
                processError = error
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if let processError {
            throw processError
        }
    }
}

#endif
