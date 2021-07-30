import Foundation
import ArgumentParser

protocol CommandDTO: Codable {
    static var command: ParsableCommand.Type { get }
    static var commandName: String { get }
    
    func toCommand() throws -> ParsableCommand
}

extension CommandDTO {
    static var commandName: String {
        return command.configuration.commandName ?? String(describing: command)
    }
}
