import Foundation
import XCResourceUtil

class CSVTableEncoder: LocalizationTableEncoder {
    func encode(_ table: LocalizationTable) throws -> String {
        var result = ""
        
        writeRow(table.header, to: &result)
        
        for record in table.records {
            writeRow(record, to: &result)
        }
        
        return result
    }
    
    private func writeRow(_ row: [String], to target: inout String) {
        target += row.map({ $0.addingCSVEncoding() }).joined(separator: ",")
        target += "\n"
    }
}
