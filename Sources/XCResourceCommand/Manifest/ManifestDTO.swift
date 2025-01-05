import Foundation

struct ManifestDTO: Codable, Sendable {
    var commands: [CommandDTOWrapper]
}
