import Foundation

private let allCommandDTOTypes: [CommandDTO.Type] = [
    XCAssetsToSwiftDTO.self, FontsToSwiftDTO.self,
    KeyToFormDTO.self,
    SwiftToStringsDTO.self, SwiftToStringsdictDTO.self,
    StringsToSwiftDTO.self, StringsdictToSwiftDTO.self,
    StringsToCSVDTO.self, CSVToStringsDTO.self,
]

struct CommandDTOWrapper: Codable {
    private enum CodingKeys: String, CodingKey {
        case commandName
    }
    
    var command: CommandDTO
    
    init(command: CommandDTO) {
        self.command = command
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commandName = try container.decode(String.self, forKey: .commandName)
        
        guard let commandType = allCommandDTOTypes.first(where: { $0.commandName == commandName })
        else {
            throw DecodingError.dataCorruptedError(
                forKey: .commandName,
                in: container,
                debugDescription: "Unknown command '\(commandName)'")
        }
        
        command = try commandType.init(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let commandName = type(of: command).commandName
        try container.encode(commandName, forKey: .commandName)
        try command.encode(to: encoder)
    }
}
