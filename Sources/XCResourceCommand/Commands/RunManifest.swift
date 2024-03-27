import Foundation
import ArgumentParser
import XCResourceUtil

struct RunManifest: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "run",
        abstract: "Run commands listed in the manifest file")
    
    // MARK: - Default values
    
    enum Default {
        static let manifestPath: String = "xcresource.json"
        fileprivate static let hiddenManifestPath: String = ".xcresource.json"
        
        fileprivate static var joinedAllManifestPaths: String {
            return "\(Default.manifestPath)|\(Default.hiddenManifestPath)"
        }
    }
    
    // MARK: - Arguments
    
    @Option(help: ArgumentHelp(valueName: Default.joinedAllManifestPaths))
    var manifestPath: String = Default.manifestPath
    
    // MARK: - Run
    
    mutating func run() throws {
        let manifestFileURL = determineManifestFileURL()
        let manifestData = try Data(contentsOf: manifestFileURL)
        let manifestDTO = try JSONDecoder().decode(ManifestDTO.self, from: manifestData)
        
        for commandDTO in manifestDTO.commands.map(\.command) {
            var command = try commandDTO.toCommand()
            try command.run()
        }
    }
    
    private func determineManifestFileURL() -> URL {
        if manifestPath != Default.manifestPath {
            return URL(fileURLWithExpandingTildeInPath: manifestPath)
        }
        
        let fm = FileManager.default
        
        let defaultManifestURL = URL(fileURLWithExpandingTildeInPath: manifestPath)
        if fm.fileExists(atPath: defaultManifestURL.path()) {
            return defaultManifestURL
        }
        
        let hiddenManifestURL = URL(fileURLWithExpandingTildeInPath: Default.hiddenManifestPath)
        if fm.fileExists(atPath: hiddenManifestURL.path()) {
            return hiddenManifestURL
        }
        
        return defaultManifestURL
    }
}
