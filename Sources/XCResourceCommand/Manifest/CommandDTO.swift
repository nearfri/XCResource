import Foundation
import ArgumentParser

protocol CommandDTO: Codable {
    static var commandType: ParsableCommand.Type { get }
    static var commandName: String { get }
    
    func toCommand() throws -> ParsableCommand
}

extension CommandDTO {
    static var commandName: String {
        return commandType.configuration.commandName ?? String(describing: commandType)
    }
}
