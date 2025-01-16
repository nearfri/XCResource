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
            return "[.]\(Default.manifestPath)[5]"
        }
    }
    
    // MARK: - Arguments
    
    @Option(help: ArgumentHelp(valueName: Default.joinedAllManifestPaths))
    var manifestPath: String = Default.manifestPath
    
    // MARK: - Run
    
    mutating func run() throws {
        let manifestFileURL = determineManifestFileURL()
        let manifestData = try Data(contentsOf: manifestFileURL)
        let manifestDTO = try decoder().decode(ManifestDTO.self, from: manifestData)
        
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
        
        let candidates: [String] = [
            Default.manifestPath,
            "\(Default.manifestPath)5",
            ".\(Default.manifestPath)",
            ".\(Default.manifestPath)5",
        ]
        
        for candidate in candidates {
            let candidateURL = URL(fileURLWithExpandingTildeInPath: candidate)
            if fm.fileExists(atPath: candidateURL.path(percentEncoded: false)) {
                return candidateURL
            }
        }
        
        return URL(fileURLWithExpandingTildeInPath: Default.manifestPath)
    }
    
    private func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.allowsJSON5 = true
        return decoder
    }
}
