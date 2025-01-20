import Foundation
import ArgumentParser

struct Config: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "config",
        abstract: "Manage and run configuration file",
        subcommands: [
            Init.self, Run.self,
        ],
        defaultSubcommand: Run.self)
}
