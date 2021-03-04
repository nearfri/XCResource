import Foundation

struct CommandRecordWrapper: Codable {
    private enum CodingKeys: String, CodingKey {
        case commandName
    }
    
    var record: CommandRecord
    
    init(record: CommandRecord) {
        self.record = record
    }
    
    init(from decoder: Decoder) throws {
        let allRecordTypes: [CommandRecord.Type] = [
            KeyToFormRecord.self, SwiftToStringsRecord.self, XCAssetsToSwiftRecord.self
        ]
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commandName = try container.decode(String.self, forKey: .commandName)
        
        guard let recordType = allRecordTypes.first(where: { $0.commandName == commandName }) else {
            throw DecodingError.dataCorruptedError(
                forKey: .commandName,
                in: container,
                debugDescription: "Unknown command '\(commandName)'")
        }
        
        record = try recordType.init(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let commandName = type(of: record).commandName
        try container.encode(commandName, forKey: .commandName)
        try record.encode(to: encoder)
    }
}
