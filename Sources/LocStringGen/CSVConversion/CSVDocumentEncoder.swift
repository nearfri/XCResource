import Foundation
import XCResourceUtil

class CSVDocumentEncoder: LocalizationDocumentEncoder {
    func encode(_ document: LocalizationDocument) throws -> String {
        var result = ""
        
        writeRow(document.header, to: &result)
        
        for record in document.records {
            writeRow(record, to: &result)
        }
        
        return result
    }
    
    private func writeRow(_ row: [String], to target: inout String) {
        target += row.map({ $0.addingCSVEncoding() }).joined(separator: ",")
        target += "\n"
    }
}
