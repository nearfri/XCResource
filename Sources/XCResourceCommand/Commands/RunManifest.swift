import Foundation
import ArgumentParser
import XCResourceUtil

struct RunManifest: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "run",
        abstract: "Run commands listed in the manifest file")
    
    // MARK: - Default values
    
    enum Default {
        static let manifestPath: String = "./xcresource.json"
    }
    
    // MARK: - Arguments
    
    @Option var manifestPath: String = Default.manifestPath
    
    // MARK: - Run
    
    mutating func run() throws {
        let manifestData = try Data(contentsOf: URL(fileURLWithExpandingTildeInPath: manifestPath))
        let manifestDTO = try JSONDecoder().decode(ManifestDTO.self, from: manifestData)
        
        for commandDTO in manifestDTO.commands.map(\.command) {
            var command = try commandDTO.toCommand()
            try command.run()
        }
    }
}
