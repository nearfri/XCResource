import Foundation
import StrixParsers

class CSVDocumentDecoder: LocalizationDocumentDecoder {
    func decode(from string: String) throws -> LocalizationDocument {
        let csv = try CSVParser().parse(string)
        let header = csv.first ?? []
        let records = Array(csv.dropFirst())
        
        let result = LocalizationDocument(header: header, records: records)
        try result.validate()
        
        return result
    }
}
