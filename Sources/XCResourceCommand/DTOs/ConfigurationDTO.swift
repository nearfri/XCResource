import Foundation

struct ConfigurationDTO: Codable, Sendable {
    var commands: [CommandDTOWrapper]
}
