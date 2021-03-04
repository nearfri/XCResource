import Foundation
import ArgumentParser

protocol CommandRecord: Codable {
    static var command: ParsableCommand.Type { get }
    static var commandName: String { get }
    
    func toCommand() throws -> ParsableCommand
}

extension CommandRecord {
    static var commandName: String {
        return command.configuration.commandName ?? String(describing: command)
    }
}
