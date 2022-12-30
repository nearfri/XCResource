import Foundation
import LocStringCore

class SetCommentWithValueLocalizationItemImporterDecorator: LocalizationItemImporter {
    private let importer: LocalizationItemImporter
    
    init(importer: LocalizationItemImporter) {
        self.importer = importer
    }
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
        var result = try importer.import(at: url)
        
        for i in result.indices {
            result[i].comment = result[i].value.replacingOccurrences(of: "\n", with: "\\n")
        }
        
        return result
    }
}
