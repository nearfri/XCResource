import Foundation
import LocStringCore

class LocalizationItemImporterCommentWithValueDecorator: LocalizationItemImporter {
    private let decoratee: LocalizationItemImporter
    
    init(decoratee: LocalizationItemImporter) {
        self.decoratee = decoratee
    }
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
        var result = try decoratee.import(at: url)
        
        for i in result.indices {
            result[i].comment = result[i].value.replacingOccurrences(of: "\n", with: "\\n")
        }
        
        return result
    }
}
