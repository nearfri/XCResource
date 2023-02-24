import Foundation
import LocStringCore

class LocalizationItemImporterFormatLabelRemovalDecorator: LocalizationItemImporter {
    private let decoratee: LocalizationItemImporter
    
    init(decoratee: LocalizationItemImporter) {
        self.decoratee = decoratee
    }
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
        var result = try decoratee.import(at: url)
        
        for i in result.indices {
            result[i].comment = result[i].commentByRemovingFormatLabels
        }
        
        return result
    }
}
