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
        let manifestRecord = try JSONDecoder().decode(ManifestRecord.self, from: manifestData)
        
        for commandRecord in manifestRecord.commands.map(\.record) {
            var command = try commandRecord.toCommand()
            try command.run()
        }
    }
}
