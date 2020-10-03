import Foundation

extension DefaultStringInterpolation {
    mutating func appendInterpolation<T: Encodable>(json value: T) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let encodedData = try encoder.encode(value)
        let string = String(decoding: encodedData, as: UTF8.self)
        appendLiteral(string)
    }
}
