import Foundation
import StrixParsers

class CSVTableDecoder: LocalizationTableDecoder {
    func decode(from string: String) throws -> LocalizationTable {
        let csv = try CSVParser().parse(string)
        let header = csv.first ?? []
        let records = Array(csv.dropFirst())
        
        let result = LocalizationTable(header: header, records: records)
        try result.validate()
        
        return result
    }
}
