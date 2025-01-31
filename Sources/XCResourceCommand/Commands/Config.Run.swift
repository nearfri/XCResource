import Foundation
import ArgumentParser
import XCResourceUtil

extension Config {
    struct Run: ParsableCommand {
        static let configuration: CommandConfiguration = .init(
            commandName: "run",
            abstract: "Run commands listed in the configuration file")
        
        // MARK: - Default values
        
        enum Default {
            static let configurationPath: String = "xcresource.json"
            
            fileprivate static var joinedAllConfigurationPaths: String {
                return "[.]\(Default.configurationPath)[5]"
            }
        }
        
        // MARK: - Arguments
        
        @Option(help: ArgumentHelp(valueName: Default.joinedAllConfigurationPaths))
        var configurationPath: String = Default.configurationPath
        
        // MARK: - Run
        
        mutating func run() throws {
            let configurationFileURL = determineConfigurationFileURL()
            let configurationData = try Data(contentsOf: configurationFileURL)
            let configurationDTO = try decoder().decode(ConfigurationDTO.self,
                                                        from: configurationData)
            
            for commandDTO in configurationDTO.commands.map(\.command) {
                var command = try commandDTO.toCommand()
                try command.run()
            }
        }
        
        private func determineConfigurationFileURL() -> URL {
            if configurationPath != Default.configurationPath {
                return URL(filePath: configurationPath, expandingTilde: true)
            }
            
            let fm = FileManager.default
            
            let candidates: [String] = [
                Default.configurationPath,
                "\(Default.configurationPath)5",
                ".\(Default.configurationPath)",
                ".\(Default.configurationPath)5",
            ]
            
            for candidate in candidates {
                let candidateURL = URL(filePath: candidate, expandingTilde: true)
                if fm.fileExists(atPath: candidateURL.path(percentEncoded: false)) {
                    return candidateURL
                }
            }
            
            return URL(filePath: Default.configurationPath, expandingTilde: true)
        }
        
        private func decoder() -> JSONDecoder {
            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true
            return decoder
        }
    }
}
