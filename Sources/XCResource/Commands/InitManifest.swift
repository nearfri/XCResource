import Foundation
import ArgumentParser

struct InitManifest: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "init",
        abstract: "Create an initial manifest file")
    
    // MARK: - Run
    
    mutating func run() throws {
        
    }
}
